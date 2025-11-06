extends Control

@onready var vida_label: Label = $Status/MarginContainer/UI/Vida
@onready var tempo_label: Label = $Status/MarginContainer/UI/Tempo
@onready var score_label: Label = $Status/MarginContainer/UI/Score
@onready var playtime: Timer = $Status/Playtime

@export 
var player : Jogador

var tempo_total : int = 0
var pontuacao : int = 0

func _ready() -> void:
	player.atualizar_vida.connect(_on_vida_alterada)
	player.atualizar_dinheiro.connect(_on_dinheiro_alterado)
	
	vida_label.text = "Vida: %d" % player.vida
	tempo_label.text = "Tempo decorrido: %02d:%02d" % [00,00]
	score_label.text = "Pontuação: %d" % player.dinheiro

@warning_ignore("unused_parameter")
func _on_vida_alterada(vida_old : int, vida : int):
	vida_label.text = "Vida: %d" % vida

func _on_dinheiro_alterado(dinheiro_old : int, dinheiro : int):
	pontuacao += (dinheiro - dinheiro_old) * roundi(tempo_total/3.0)
	score_label.text = "Pontuação: %d" % pontuacao


func _on_playtime_timeout() -> void:
	tempo_total += 1
	@warning_ignore("integer_division")
	var m = tempo_total / 60
	var s = tempo_total % 60
	tempo_label.text = "Tempo decorrido: %02d:%02d" % [m, s]
