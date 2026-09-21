## Script do robô companion Byte.
## Segue o Léo, dá dicas progressivas e reage a erros nos puzzles.
extends CharacterBody2D

@export var follow_speed: float = 150.0
@export var follow_distance: float = 48.0

var target: CharacterBody2D = null
var idle_time: float = 0.0

@onready var visual: Panel = $Visual
@onready var message_label: Label = $MessageLabel
@onready var message_timer: Timer = $MessageTimer


func _ready() -> void:
	message_label.visible = false
	message_timer.timeout.connect(hide_message)


func _physics_process(delta: float) -> void:
	if target == null:
		return

	var distance = global_position.distance_to(target.global_position)
	var direction = global_position.direction_to(target.global_position)

	if distance > follow_distance:
		velocity = direction * follow_speed
		idle_time = 0.0
	else:
		velocity = Vector2.ZERO
		# Animação de bounce sutil quando parado
		idle_time += delta
		visual.position.y = sin(idle_time * 3.0) * 2.0

	move_and_slide()


## Define quem o Byte vai seguir
func set_target(node: CharacterBody2D) -> void:
	target = node


## Mostra uma mensagem no balão de texto
func show_message(text: String, duration: float = 3.0) -> void:
	message_label.text = text
	message_label.visible = true
	message_timer.wait_time = duration
	message_timer.start()


## Esconde a mensagem
func hide_message() -> void:
	message_label.visible = false
	message_label.text = ""


## Retorna a dica apropriada baseada no número de erros
func get_hint(error_count: int, puzzle_data: PuzzleData) -> String:
	match error_count:
		1:
			return puzzle_data.hint_concept
		2:
			return puzzle_data.hint_clue
		_:
			return puzzle_data.hint_reasoning


## Mostra a dica na tela
func show_hint(error_count: int, puzzle_data: PuzzleData) -> void:
	var hint_text = get_hint(error_count, puzzle_data)
	show_message(hint_text, 5.0)


## Reação do Byte quando o jogador erra
func show_error_reaction(error_count: int) -> void:
	var reactions = [
		"Hmm, não foi dessa vez...",
		"Tenta de novo! Olha as pistas ao redor.",
		"Calma, vamos pensar junto..."
	]
	var index = clampi(error_count - 1, 0, reactions.size() - 1)
	show_message(reactions[index], 3.0)
