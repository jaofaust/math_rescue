## Objeto que dispara a abertura de um puzzle quando interagido.
extends Node2D

@export var puzzle_resource: PuzzleData
@export var interaction_prompt: String = "Pressione E para examinar"

var is_solved: bool = false

@onready var interaction_area: Area2D = $InteractionArea
@onready var visual: ColorRect = $Visual
@onready var glow: ColorRect = $Glow
@onready var label: Label = $Label

signal puzzle_triggered(puzzle_data: PuzzleData)


func _ready() -> void:
	# Verificar se já foi resolvido
	if puzzle_resource and GameManager.is_puzzle_solved(puzzle_resource.puzzle_id):
		_mark_as_solved()

	GameManager.puzzle_solved.connect(_on_puzzle_solved)

	# Animação de pulsação no glow
	if not is_solved:
		_start_glow_animation()


## Chamado quando o jogador interage
func interact() -> void:
	if is_solved:
		return

	if puzzle_resource:
		puzzle_triggered.emit(puzzle_resource)


## Retorna o texto do prompt
func get_interaction_prompt() -> String:
	if is_solved:
		return "Já resolvido ✓"
	return interaction_prompt


## Quando qualquer puzzle é resolvido, verifica se é este
func _on_puzzle_solved(puzzle_id: String) -> void:
	if puzzle_resource and puzzle_id == puzzle_resource.puzzle_id:
		_mark_as_solved()


## Marca visualmente como resolvido com animação
func _mark_as_solved() -> void:
	is_solved = true

	# Animação de resolução
	var tween = create_tween()
	tween.tween_property(visual, "color", Color(0.2, 0.7, 0.3, 1.0), 0.3)
	tween.parallel().tween_property(glow, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_callback(func(): label.text = "✓")


## Animação de pulsação do glow
func _start_glow_animation() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(glow, "modulate", Color(1, 1, 1, 0.6), 0.8)
	tween.tween_property(glow, "modulate", Color(1, 1, 1, 0.2), 0.8)
