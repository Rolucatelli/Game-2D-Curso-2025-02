extends CanvasLayer

@onready var vida_label: Label = $Vida
@onready var score_label: Label = $Score
@export 
var player : Jogador
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.atualizar_interface.connect(_on_valor_alterado)
	vida_label.text = "Vida: %d" % player.vida
	score_label.text = "Pontuação: %d" % player.dinheiro


func _on_valor_alterado(vida:int, dinheiro:int):
	vida_label.text = "Vida: %d" % vida
	score_label.text = "Pontuação: %d" % dinheiro
	
