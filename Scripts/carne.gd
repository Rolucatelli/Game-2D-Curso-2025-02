extends Node2D

@export
var valor := 3

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jogador and body.vida < body.vida_maxima:
		if body.vida + valor >= body.vida_maxima:
			body.vida = body.vida_maxima
		else:
			body.vida += valor
		queue_free()
