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

func processa_comando(event: InputEvent) -> Estado:
	if not parent.atacando:
		var h_direction := Input.get_axis("Esquerda", "Direita")
		var v_direction := Input.get_axis("Cima", "Baixo")
		
		if h_direction or v_direction:
			return estado_andar
		else:
			return estado_idle
	return null

func processa_fisica(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	
	var h_direction := Input.get_axis("Esquerda", "Direita")
	var v_direction := Input.get_axis("Cima", "Baixo")
	parent.animacoes.flip_h = mouse_pos.x < parent.position.x
	
	if h_direction or v_direction:
		parent.velocity = Vector2(h_direction, v_direction).normalized() * (parent.velocidade/2)
	else:
		parent.velocity = Vector2(0, 0)
		if not parent.atacando:
			return estado_idle
	parent.move_and_slide()
	
	return null
