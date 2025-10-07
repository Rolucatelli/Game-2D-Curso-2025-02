extends Estado


func enter() -> void:
	#Executando a função padrão do estado (Comeca a animação desse nó)
	super()
	parent.velocity.x = 0
	parent.velocity.y = 0
	parent.health_bar.visible = false

func _on_animacoes_animation_finished() -> void:
	if parent.animacoes.animation == "Morte":
		get_tree().reload_current_scene()
