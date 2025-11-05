extends Estado

@export
var estado_andar: Estado
@export
var estado_ataque1: Estado
@export
var estado_morto: Estado


func processa_frame(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	if Input.get_vector("Esquerda", "Direita", "Cima", "Baixo"):
		return estado_andar
	if Input.is_action_just_pressed("Ataque"):
		return estado_ataque1
	return null

func processa_frame_fisica(delta: float) -> Estado:
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	return null
