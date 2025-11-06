extends Node2D

@export
var valor := 3

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jogador:
		body.dinheiro += valor
		queue_free()
