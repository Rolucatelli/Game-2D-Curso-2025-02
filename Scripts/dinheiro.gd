extends Node2D

@export
var valor := 3

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jogador:
		body.dinheiro += valor
		body.atualizar_interface.emit(body.vida, body.dinheiro)
		queue_free()
