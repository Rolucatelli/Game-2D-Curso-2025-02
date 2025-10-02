extends Estado

@export
var estado_idle: Estado
@export
var estado_ataque1: Estado
@export
var estado_morto: Estado


func enter() -> void:
	#Executando a função padrão do estado (Comeca a animação desse nó)
	super()



func processa_comando(event: InputEvent) -> Estado:
	var h_direction := Input.get_axis("Esquerda", "Direita")
	var v_direction := Input.get_axis("Cima", "Baixo")
	
	if h_direction == 0 and v_direction == 0:
		return estado_idle
	if Input.is_action_just_pressed("Ataque"):
		return estado_ataque1
	return null

func processa_fisica(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	
	var h_direction := Input.get_axis("Esquerda", "Direita")
	var v_direction := Input.get_axis("Cima", "Baixo")
	if h_direction != 0:
		parent.animacoes.flip_h = h_direction < 0
	
	if h_direction or v_direction:
		parent.velocity = (Vector2(h_direction, v_direction).normalized()) * parent.velocidade
	else:
		return estado_idle
	parent.move_and_slide()
	
	return null
