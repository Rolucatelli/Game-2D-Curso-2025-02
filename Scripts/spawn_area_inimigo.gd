# Spawner.gd
extends Marker2D

@onready var timer: Timer = $Timer

@export var enemy_scene: PackedScene = preload("res://Cenas/inimigo.tscn")
@export var max_amount: int = 10
@export var initial_amount: int = 1
@export var batch_size: int = 3
@export var spawn_time: float = 5.0
@export var area: Vector2 = Vector2(100, 100)

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	call_deferred("spawn_initial")
	timer.start(spawn_time)

func spawn_initial() -> void:
	for i in range(initial_amount):
		spawn_enemy()

func spawn_enemy() -> void:
	for i in range(batch_size):
		var half = area * 0.5
		var rx = rng.randf_range(-half.x, half.x)
		var ry = rng.randf_range(-half.y, half.y)
		var spawn_pos = global_position + Vector2(rx, ry)
		
		var enemy = enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = spawn_pos
		enemy.alvo = get_tree().get_first_node_in_group("jogador")
		if timer.is_stopped():
			timer.start(spawn_time)

func _on_timer_timeout() -> void:
	spawn_enemy()
