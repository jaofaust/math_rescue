## Praça Central — Zona 1 (tutorial implícito) e Zona 2 (puzzle da porta).
## Primeira cena do jogo onde o jogador aprende a se mover e resolver puzzles.
extends Node2D

@onready var leo: CharacterBody2D = $Leo
@onready var byte_companion: CharacterBody2D = $ByteCompanion
@onready var puzzle_panel: Control = $UI/PuzzlePanelLayer/PuzzlePanel
@onready var hud: CanvasLayer = $UI/HUD
@onready var door: StaticBody2D = $Zona2/Door
@onready var puzzle_trigger: Node2D = $Zona2/PuzzleTrigger
@onready var transition_area: Area2D = $TransitionArea
@onready var zona2_chao: ColorRect = $Zona2/Chao
@onready var success_label: Label = $SuccessLabel
@onready var cabo_2: Panel = $Zona2/Cabo2


func _ready() -> void:
	# Configurar Byte para seguir Léo
	byte_companion.set_target(leo)
	GameManager.player = leo
	GameManager.byte_companion = byte_companion

	# Conectar puzzle trigger ao painel
	puzzle_trigger.puzzle_triggered.connect(_on_puzzle_triggered)

	# Conectar eventos de puzzle
	puzzle_panel.puzzle_completed.connect(_on_puzzle_completed)
	puzzle_panel.puzzle_error.connect(_on_puzzle_error)

	# Conectar dica do Léo ao Byte
	leo.hint_requested.connect(_on_hint_requested)

	# Conectar transição
	transition_area.body_entered.connect(_on_transition_body_entered)

	# Objetivo inicial
	hud.set_objective("Explore a Praça Central")

	# Esconder label de sucesso
	success_label.visible = false

	# Se recarregar o nível com o puzzle já feito, deixa o cabo verde
	if GameManager.is_puzzle_solved("porta_unidades"):
		_set_cabo_2_green()


## Quando o jogador interage com um puzzle trigger
func _on_puzzle_triggered(puzzle_data: PuzzleData) -> void:
	puzzle_panel.open_puzzle(puzzle_data)


## Quando o jogador acerta o puzzle
func _on_puzzle_completed(puzzle_id: String) -> void:
	if puzzle_id == "porta_unidades":
		hud.set_objective("A porta abriu! Siga em frente.")
		byte_companion.show_message("Muito bem! Vamos lá!", 4.0)

		# Efeito visual: "luzes acendem" na Zona 2
		_play_success_effect()
		_set_cabo_2_green()


## Altera a cor da etiqueta "2 m" para verde (cabo correto conectado)
func _set_cabo_2_green() -> void:
	var style_green = StyleBoxFlat.new()
	style_green.bg_color = Color("#51CF66") # Verde acerto do GDD
	style_green.corner_radius_top_left = 4
	style_green.corner_radius_top_right = 4
	style_green.corner_radius_bottom_right = 4
	style_green.corner_radius_bottom_left = 4
	style_green.anti_aliasing = true
	cabo_2.add_theme_stylebox_override("panel", style_green)


## Efeito visual de sucesso — luzes acendem, cenário muda de cor
func _play_success_effect() -> void:
	# Mostrar mensagem grande de sucesso
	success_label.visible = true
	success_label.text = "✓ PORTA DESTRANCADA!"
	success_label.modulate = Color("#51CF66")

	# Animar a Zona 2 ficando mais clara (luzes acendendo para #252849)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(zona2_chao, "color", Color("#141529"), 1.0)

	# Fade out da mensagem de sucesso
	var label_tween = create_tween()
	label_tween.tween_interval(2.0)
	label_tween.tween_property(success_label, "modulate", Color(0.31, 0.81, 0.4, 0.0), 1.0)
	label_tween.tween_callback(func(): success_label.visible = false)


## Quando o jogador erra o puzzle
func _on_puzzle_error(error_count: int, puzzle_data: PuzzleData) -> void:
	byte_companion.show_error_reaction(error_count)
	hud.show_hint_available(true)


## Quando o jogador pede dica ao Byte
func _on_hint_requested() -> void:
	if GameManager.current_puzzle_data:
		byte_companion.show_hint(GameManager.current_puzzle_errors, GameManager.current_puzzle_data)


## Quando o jogador entra na área de transição
func _on_transition_body_entered(body: Node2D) -> void:
	if body == leo and door.is_open:
		# Transição para Sala do Mercado
		get_tree().change_scene_to_file("res://scenes/levels/sala_mercado.tscn")
