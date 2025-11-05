extends Estado

@export
var estado_idle: Estado
@export
var estado_andar: Estado
@export
var estado_morto: Estado

var mouse_pos : Vector2

func enter() -> void:
	mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	super()
	parent.dano = 5
	parent.atacando = true
	parent.hitbox.monitoring = true
	parent.hitbox.visible = true
	parent.hitbox.look_at(mouse_pos)

func exit() -> void:
	parent.dano = 3
	parent.atacando = false
	parent.hitbox.monitoring = false
	parent.hitbox.visible = false

func _on_animacoes_animation_finished() -> void:
	parent.atacando = false
	parent.hitbox.monitoring = true
	parent.hitbox.visible = true

func processa_frame(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	if not parent.atacando:
		if Input.get_vector("Esquerda", "Direita", "Cima", "Baixo"):
			return estado_andar
		else:
			return estado_idle
	return null

func processa_frame_fisica(delta: float) -> Estado:
	parent.animacoes.flip_h = mouse_pos.x < parent.position.x
	
	parent.velocity = Input.get_vector("Esquerda", "Direita", "Cima", "Baixo").normalized() \
	* ((parent.velocidade/2) * delta)
	
	parent.move_and_slide()
	return null
