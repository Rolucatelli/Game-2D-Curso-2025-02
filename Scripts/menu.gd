extends Control

@onready var jogar: Button = $PanelContainer/MarginContainer2/VBoxContainer/MarginContainer/Jogar
@onready var creditos: Button = $PanelContainer/MarginContainer2/VBoxContainer/MarginContainer2/Creditos
@onready var sair: Button = $PanelContainer/MarginContainer2/VBoxContainer/MarginContainer3/Sair


func _on_jogar_pressed() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://Cenas/game.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_creditos_pressed() -> void:
	print("hello")
