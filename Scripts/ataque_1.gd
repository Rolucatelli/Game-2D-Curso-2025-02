extends Estado

@export
var estado_idle: Estado
@export
var estado_andar: Estado
@export
var estado_ataque2: Estado
@export
var estado_morto: Estado

var mouse_pos : Vector2

func enter() -> void:
	mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	super()
	parent.atacando = true
	parent.hitbox.visible = true
	parent.hitbox.monitoring = true
	parent.hitbox.look_at(mouse_pos)

func exit() -> void:
	parent.atacando = false
	parent.ataque_combo = false
	parent.hitbox.monitoring = false
	parent.hitbox.visible = false

func _on_animacoes_animation_finished() -> void:
	parent.atacando = false

func processa_comando(event: InputEvent) -> Estado:
	if Input.is_action_just_pressed("Ataque"):
		parent.ataque_combo = true
	if not parent.atacando:
		var h_direction := Input.get_axis("Esquerda", "Direita")
		var v_direction := Input.get_axis("Cima", "Baixo")
		
		if parent.ataque_combo:
			return estado_ataque2
		if (h_direction or v_direction):
			return estado_andar
		if !h_direction and !v_direction:
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
			if parent.ataque_combo:
				return estado_ataque2
			return estado_idle
	parent.move_and_slide()
	
	return null
