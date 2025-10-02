extends Estado

var fim_animacao := false

func enter() -> void:
	#Executando a função padrão do estado (Comeca a animação desse nó)
	super()
	parent.velocity.x = 0
	parent.velocity.y = 0

func processa_fisica(delta: float) -> Estado:
	if fim_animacao:
		get_tree().reload_current_scene()
	
	return null

func _on_animacoes_animation_finished() -> void:
	fim_animacao = true
