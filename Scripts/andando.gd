extends Estado

@export
var estado_idle: Estado
@export
var estado_ataque1: Estado
@export
var estado_morto: Estado

func processa_frame(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	if not Input.get_vector("Esquerda", "Direita", "Cima", "Baixo"):
		return estado_idle
	if Input.is_action_pressed("Ataque"):
		return estado_ataque1
	return null

func processa_frame_fisica(delta: float) -> Estado:
	var h_direction := Input.get_axis("Esquerda", "Direita")
	var v_direction := Input.get_axis("Cima", "Baixo")
	if h_direction != 0:
		parent.animacoes.flip_h = h_direction < 0
	
	parent.velocity = (Vector2(h_direction, v_direction).normalized()) \
	 * (parent.velocidade * delta)
	parent.move_and_slide()
	
	return null
