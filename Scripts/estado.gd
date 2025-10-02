class_name Estado
extends Node

@export
var nome_animacao: String

var parent: Jogador

func enter() -> void:
	parent.animacoes.play(nome_animacao)

func exit() -> void:
	pass

func processa_fisica(delta: float) -> Estado:
	return null

func processa_comando(evento: InputEvent) -> Estado:
	return null

func processa_frame(delta: float) -> Estado:
	return null
