class_name MaquinaEstados
extends Node

@export
var estado_inicial: Estado

var estado_atual: Estado
var parent_m: Jogador

func init(parent: Jogador) -> void:
	parent_m = parent
	for child in get_children():
		child.parent = parent
	
	troca_estado(estado_inicial)

func troca_estado(novo_estado: Estado) -> void:
	if estado_atual:
		estado_atual.exit()
	
	estado_atual = novo_estado
	novo_estado.enter()

func processa_fisica(delta: float) -> void:
	if parent_m.invulneravel and parent_m.timer_invulneravel.is_stopped():
		parent_m.timer_invulneravel.start(parent_m.tempo_invulneravel)
		parent_m.velocity.x = parent_m.velocity.x / 2
		parent_m.velocity.y = parent_m.velocity.y / 2
		parent_m.modulate = Color("#ffffff", 0.5)
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

func _on_tempo_invulneravel_timeout() -> void:
	parent_m.invulneravel = false
	parent_m.modulate = Color("#ffffff", 1)
	parent_m.timer_invulneravel.stop()
