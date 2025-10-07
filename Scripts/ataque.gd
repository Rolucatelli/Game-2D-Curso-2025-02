extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox_scan: Area2D = $"Hitbox Scan"
@export
var monitoring := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	hitbox_scan.monitoring = monitoring
	var parent:= get_parent()
	if parent is Jogador:
		hitbox_scan.set_collision_layer_value(1, true)
		hitbox_scan.set_collision_mask_value(2, true)
	elif parent is Inimigo:
		hitbox_scan.set_collision_layer_value(2, true)
		hitbox_scan.set_collision_mask_value(1, true)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		animation_player.play("Ataque")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if (body is Jogador and not body.invulneravel) or body is Inimigo:
		if body.vida < get_parent().dano:
			body.vida = 0
		else:
			body.vida -= get_parent().dano
			if body is Jogador:
				body.atualizar_interface.emit(body.vida, body.dinheiro)
				body.invulneravel = true
			print(body,":", body.vida)
		
