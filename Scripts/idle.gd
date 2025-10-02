extends Estado

@export
var estado_andar: Estado
@export
var estado_ataque1: Estado
@export
var estado_morto: Estado

func enter() -> void:
	#Executando a função padrão do estado (Comeca a animação desse nó)
	super()
	parent.velocity.x = 0
	parent.velocity.y = 0


func processa_comando(event: InputEvent) -> Estado:
	var andando_v = Input.is_action_just_pressed("Baixo") or Input.is_action_just_pressed("Cima")
	var andando_h = Input.is_action_just_pressed("Esquerda") or Input.is_action_just_pressed("Direita")
	
	if andando_v or andando_h:
		return estado_andar
	if Input.is_action_just_pressed("Ataque"):
		return estado_ataque1
	return null

func processa_fisica(delta: float) -> Estado:
	if parent.vida <= 0:
		return estado_morto
	parent.move_and_slide()
	return null
