class_name MaquinaEstados
extends Node

@export
var estado_inicial: Estado

var estado_atual: Estado

func init(parent: Jogador) -> void:
	for child in get_children():
		child.parent = parent
	
	troca_estado(estado_inicial)

func troca_estado(novo_estado: Estado) -> void:
	if estado_atual:
		estado_atual.exit()
	
	estado_atual = novo_estado
	novo_estado.enter()

func processa_fisica(delta: float) -> void:
	var novo_estado = estado_atual.processa_fisica(delta)
	if novo_estado:
		troca_estado(novo_estado)
	
func processa_comando(evento: InputEvent) -> void:
	var novo_estado = estado_atual.processa_comando(evento)
	if novo_estado:
		troca_estado(novo_estado)
	
func processa_frame(delta: float) -> void:
	var novo_estado = estado_atual.processa_frame(delta)
	if novo_estado:
		troca_estado(novo_estado)
	
