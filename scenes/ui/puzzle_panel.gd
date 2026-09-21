## Painel de puzzle com múltipla escolha.
## Mostra contexto, pergunta e opções. Feedback visual de acerto/erro.
extends Control

var current_puzzle: PuzzleData = null
var error_count: int = 0

@onready var overlay: ColorRect = $Overlay
@onready var panel: PanelContainer = $PanelContainer
@onready var title_label: Label = $PanelContainer/VBoxMain/HeaderPanel/TitleLabel
@onready var context_label: Label = $PanelContainer/VBoxMain/ContentMargin/VBoxContent/ContextLabel
@onready var question_label: Label = $PanelContainer/VBoxMain/ContentMargin/VBoxContent/QuestionLabel
@onready var options_container: HBoxContainer = $PanelContainer/VBoxMain/ContentMargin/VBoxContent/OptionsContainer
@onready var flash_rect: ColorRect = $FlashRect

signal puzzle_completed(puzzle_id: String)
signal puzzle_error(error_count_val: int, puzzle_data: PuzzleData)

# Estilos personalizados para os botões do puzzle
var style_normal: StyleBoxFlat
var style_hover: StyleBoxFlat
var style_wrong: StyleBoxFlat


func _ready() -> void:
	visible = false
	flash_rect.color = Color(0, 0, 0, 0)
	_setup_button_styles()


## Cria os estilos dos botões via código para não depender de arquivos externos
func _setup_button_styles() -> void:
	# Estilo normal (Fundo dark #1A1A2E, Borda Roxo principal #4A4AE8)
	style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color("#1A1A2E")
	style_normal.border_width_left = 1
	style_normal.border_width_top = 1
	style_normal.border_width_right = 1
	style_normal.border_width_bottom = 1
	style_normal.border_color = Color("#4A4AE8")
	style_normal.corner_radius_top_left = 8
	style_normal.corner_radius_top_right = 8
	style_normal.corner_radius_bottom_right = 8
	style_normal.corner_radius_bottom_left = 8
	style_normal.anti_aliasing = true

	# Estilo hover/foco (Fundo um pouco mais claro, Borda Roxo médio #6C63FF)
	style_hover = style_normal.duplicate()
	style_hover.bg_color = Color("#252849")
	style_hover.border_color = Color("#6C63FF")
	style_hover.border_width_left = 2
	style_hover.border_width_top = 2
	style_hover.border_width_right = 2
	style_hover.border_width_bottom = 2

	# Estilo errado (Borda Vermelho erro #FF6B6B)
	style_wrong = style_normal.duplicate()
	style_wrong.bg_color = Color("#1A1A2E")
	style_wrong.border_color = Color("#FF6B6B")
	style_wrong.border_width_left = 2
	style_wrong.border_width_top = 2
	style_wrong.border_width_right = 2
	style_wrong.border_width_bottom = 2


## Abre o painel com os dados do puzzle
func open_puzzle(puzzle_data: PuzzleData) -> void:
	if puzzle_data == null:
		return

	current_puzzle = puzzle_data
	error_count = 0
	GameManager.current_puzzle_errors = 0
	GameManager.current_puzzle_data = puzzle_data
	GameManager.set_state(GameManager.GameState.PUZZLE)

	# Título e Conteúdo
	if puzzle_data.puzzle_id == "porta_unidades":
		title_label.text = "Painel de Controle — Porta da Praça"
	elif puzzle_data.puzzle_id == "receita_proporcao":
		title_label.text = "Máquina de Cálculo — Proporções"
	else:
		title_label.text = "Painel de Controle"

	context_label.text = puzzle_data.context_text
	question_label.text = puzzle_data.question

	# Criar botões de opção
	_create_option_buttons()

	# Mostrar painel
	visible = true
	_animate_open()


## Fecha o painel
func close_puzzle() -> void:
	_animate_close()
	await get_tree().create_timer(0.3).timeout
	visible = false
	current_puzzle = null
	GameManager.set_state(GameManager.GameState.EXPLORING)
	GameManager.reset_puzzle_errors()


## Cria os botões de opção dinamicamente em linha horizontal
func _create_option_buttons() -> void:
	# Limpar opções anteriores
	for child in options_container.get_children():
		child.queue_free()

	# Criar novos botões lado a lado
	for i in range(current_puzzle.options.size()):
		var button = Button.new()
		button.text = current_puzzle.options[i]
		button.custom_minimum_size = Vector2(160, 60)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.mouse_filter = Control.MOUSE_FILTER_STOP

		# Aplicar estilos customizados
		button.add_theme_stylebox_override("normal", style_normal)
		button.add_theme_stylebox_override("hover", style_hover)
		button.add_theme_stylebox_override("pressed", style_hover)
		button.add_theme_stylebox_override("focus", style_hover)
		button.add_theme_font_size_override("font_size", 16)

		button.pressed.connect(_on_option_selected.bind(i, button))
		options_container.add_child(button)


## Quando uma opção é selecionada
func _on_option_selected(index: int, button_node: Button) -> void:
	if current_puzzle == null:
		return

	if index == current_puzzle.correct_index:
		# ACERTOU!
		AudioManager.play_success()
		var success_color = Color("#51CF66")
		success_color.a = 0.3
		_flash_color(success_color, 0.5)
		GameManager.solve_puzzle(current_puzzle.puzzle_id, current_puzzle.energy_reward)
		puzzle_completed.emit(current_puzzle.puzzle_id)

		# Desabilitar botões
		_disable_buttons()

		# Fechar após delay
		await get_tree().create_timer(1.0).timeout
		close_puzzle()
	else:
		# ERROU!
		AudioManager.play_error()
		error_count += 1
		GameManager.register_puzzle_error()
		
		# Feedback no próprio botão (borda vermelha e ícone de erro " ✗")
		button_node.add_theme_stylebox_override("normal", style_wrong)
		if not button_node.text.ends_with(" ✗"):
			button_node.text += " ✗"
			button_node.add_theme_color_override("font_color", Color("#FF6B6B"))

		var error_color = Color("#FF6B6B")
		error_color.a = 0.3
		_flash_color(error_color, 0.3)
		puzzle_error.emit(error_count, current_puzzle)


## Flash de cor na tela (verde ou vermelho)
func _flash_color(color: Color, duration: float) -> void:
	flash_rect.color = color
	var tween = create_tween()
	tween.tween_property(flash_rect, "color", Color(0, 0, 0, 0), duration)


## Animação de abertura
func _animate_open() -> void:
	panel.modulate = Color(1, 1, 1, 0)
	panel.scale = Vector2(0.9, 0.9)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(panel, "modulate", Color(1, 1, 1, 1), 0.3)
	tween.tween_property(panel, "scale", Vector2(1, 1), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0.4), 0.3)


## Animação de fechamento
func _animate_close() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(panel, "modulate", Color(1, 1, 1, 0), 0.3)
	tween.tween_property(panel, "scale", Vector2(0.9, 0.9), 0.3)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0), 0.3)


## Desabilita todos os botões
func _disable_buttons() -> void:
	for child in options_container.get_children():
		if child is Button:
			child.disabled = true
			# Garantir que não mude de estilo no hover
			child.add_theme_stylebox_override("disabled", style_normal)
