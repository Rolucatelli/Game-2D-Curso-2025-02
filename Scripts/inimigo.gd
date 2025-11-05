# Inimigo.gd
class_name Inimigo
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ataque: Node2D = $Ataque
@onready var health_bar: ProgressBar = $HealthBar

@export var carne_scene: PackedScene = preload("res://Cenas/carne.tscn")
@export var dinheiro_scene: PackedScene = preload("res://Cenas/dinheiro.tscn")

@export var alvo: Node2D = null
@export var SPEED := 9000.0
@export var vida := 5.0:
	set(value):
		vida = clamp(value, 0, vida_maxima)
		health_bar.value = vida
@export var vida_maxima := 5.0
@export var dano := 3.0
@export var alcance_ataque := 100.0
@export var follow_range := 65.0
@export var follow_timer := 5.0
@export var chance_drop := 0.15


enum Estados { Andando, Atacando, Morte }
var estado_atual : Estados = Estados.Andando
var atacando := false
var follow_time : float = 0.0
var offset : Vector2


func _ready() -> void:
	add_to_group("inimigo")
	ataque.monitoring = false
	
	
	health_bar.value = vida
	health_bar.max_value = vida_maxima
	
	if not is_instance_valid(alvo):
		alvo = get_tree().get_first_node_in_group("jogador")

func _process(delta: float) -> void:
	print(delta)
	ataque.visible = false
	ataque.monitoring = false
	follow_time -= delta
	if follow_time <= 0:
		offset = Vector2(randf_range(-follow_range, follow_range),randf_range(-follow_range, follow_range))
		follow_time = follow_timer
	
	maquina_de_estados(delta)
	move_and_slide()
	

func maquina_de_estados(delta: float) -> void:
	if vida <= 0:
		estado_atual = Estados.Morte
	match estado_atual:
		Estados.Andando:
			
			animated_sprite_2d.play("Andando")
			velocity = (alvo.global_position + offset - global_position).normalized()\
			* (SPEED * delta)
			
			animated_sprite_2d.flip_h = alvo.global_position.x < global_position.x
			
			if global_position.distance_to(alvo.global_position) <= alcance_ataque:
				estado_atual = Estados.Atacando
				
				ataque.look_at(alvo.global_position)
				atacando = true
			
		Estados.Atacando:
			
			animated_sprite_2d.play("Ataque")
			velocity = Vector2.ZERO
			ataque.monitoring = true
			ataque.visible = true
			
			if global_position.distance_to(alvo.global_position) > alcance_ataque and not atacando:
				estado_atual = Estados.Andando
			
		Estados.Morte:
			velocity = Vector2.ZERO
			health_bar.visible = false
			animated_sprite_2d.play("Morte")
		

func gerar_drop():
	var chance := randf()
	var drop = carne_scene.instantiate() if chance <= chance_drop else dinheiro_scene.instantiate()
	get_tree().current_scene.get_node("Game").add_child(drop)
	drop.global_position = position

func _on_animation_finished() -> void:
	var anim = animated_sprite_2d.animation
	if anim == "Morte":
		gerar_drop()
		queue_free()
	elif anim == "Ataque":
		atacando = false
