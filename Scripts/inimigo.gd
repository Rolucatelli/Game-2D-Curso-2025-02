# Inimigo.gd
class_name Inimigo
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ataque: Node2D = $Ataque
@onready var health_bar: ProgressBar = $HealthBar

@export var carne_scene: PackedScene = preload("res://Cenas/carne.tscn")
@export var dinheiro_scene: PackedScene = preload("res://Cenas/dinheiro.tscn")

@export var alvo: Node2D = null
@export var SPEED := 150.0
@export var vida := 5.0:
	set(value):
		vida = clamp(value, 0, vida_maxima)
		health_bar.value = vida
@export var vida_maxima := 5.0
@export var dano := 3.0
@export var alcance_ataque := 100.0
@export var follow_range := 80.0
@export var follow_timer := 5.0


enum Estados { Andando, Atacando, Morte }
var estado_atual : Estados = Estados.Andando
var atacando := false
var follow_time : float = 0.0
var offset : Vector2


func _ready() -> void:
	ataque.monitoring = false
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	health_bar.value = vida
	health_bar.max_value = vida_maxima
	if not is_instance_valid(alvo):
		alvo = get_tree().get_first_node_in_group("jogador")

func set_alvo_by_group(group_name: String) -> void:
	var n = get_tree().get_first_node_in_group(group_name)
	if is_instance_valid(n):
		alvo = n
		print("Inimigo: alvo definido por grupo -> ", alvo.name)
	else:
		call_deferred("set_alvo_by_group", group_name)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(alvo):
		alvo = get_tree().get_first_node_in_group("jogador")
		if not is_instance_valid(alvo):
			return
	
	var distancia_alvo := global_position.distance_to(alvo.global_position)
	ataque.visible = false
	
	follow_time -= delta
	if follow_time <= 0:
		offset = Vector2(randf_range(-follow_range, follow_range),randf_range(-follow_range, follow_range))
		follow_time = follow_timer
	
	match estado_atual:
		Estados.Andando:
			
			animated_sprite_2d.play("Andando")
			velocity = (alvo.global_position + offset - global_position).normalized() * SPEED
			animated_sprite_2d.flip_h = alvo.global_position.x < global_position.x
			
			if vida <= 0:
				estado_atual = Estados.Morte
			elif distancia_alvo <= alcance_ataque:
				estado_atual = Estados.Atacando
				atacando = true
			
		Estados.Atacando:
			
			animated_sprite_2d.play("Ataque")
			ataque.monitoring = true
			velocity = Vector2.ZERO
			ataque.visible = true
			ataque.look_at(alvo.global_position)
			
			if vida <= 0:
				estado_atual = Estados.Morte
			elif distancia_alvo > alcance_ataque and not atacando:
				estado_atual = Estados.Andando
			
		Estados.Morte:
			
			velocity = Vector2.ZERO
			health_bar.visible = false
			animated_sprite_2d.play("Morte")
		
	move_and_slide()

func _on_animation_finished() -> void:
	var anim = animated_sprite_2d.animation
	if anim == "Morte":
		var chance := randf()
		if chance <= 0.15:
			var carne = carne_scene.instantiate()
			get_tree().current_scene.add_child(carne)
			carne.global_position = position
		else:
			var dinheiro = dinheiro_scene.instantiate()
			get_tree().current_scene.add_child(dinheiro)
			dinheiro.global_position = position
		queue_free()
	elif anim == "Ataque":
		atacando = false
