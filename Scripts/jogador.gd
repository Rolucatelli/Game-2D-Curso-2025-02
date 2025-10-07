class_name Jogador
extends CharacterBody2D

@onready var animacoes: AnimatedSprite2D = $Animacoes
@onready var maquina_de_estados: MaquinaEstados = $"Maquina de estados"
@onready var hitbox: Node2D = $Ataque
@onready var timer_invulneravel: Timer = $TempoInvulneravel
@onready var health_bar: ProgressBar = $HealthBar

@export
var velocidade: float = 300.0
@export
var vida: int = 30:
	set(value):
		vida = clamp(value, 0, vida_maxima)
		health_bar.value = vida
@export
var vida_maxima: int = 30
@export
var dinheiro: int = 0
@export
var dano: int = 3
@export
var tempo_invulneravel: float = 1.0

var atacando := false

var ataque_combo := false

var invulneravel := false

signal atualizar_interface(vida, dinheiro)

func _ready() -> void:
	add_to_group("jogador")
	health_bar.value = vida
	health_bar.max_value = vida_maxima
	maquina_de_estados.init(self)

func _unhandled_input(event: InputEvent) -> void:
	maquina_de_estados.processa_comando(event)

func _physics_process(delta: float) -> void:
	maquina_de_estados.processa_fisica(delta)

func _process(delta: float) -> void:
	maquina_de_estados.processa_frame(delta)
