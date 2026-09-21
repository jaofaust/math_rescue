## Sala do Mercado — Zona 3 (puzzle de proporção com Dona Mira).
## Segunda cena do jogo.
extends Node2D

@onready var leo: CharacterBody2D = $Leo
@onready var byte_companion: CharacterBody2D = $ByteCompanion
@onready var puzzle_panel: Control = $UI/PuzzlePanelLayer/PuzzlePanel
@onready var hud: CanvasLayer = $UI/HUD
@onready var puzzle_trigger: Node2D = $MaquinaCalculo
@onready var dona_mira: CharacterBody2D = $DonaMira


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

	# Objetivo
	hud.set_objective("Fale com Dona Mira no Mercado")
	hud.update_energy(GameManager.energy_level)

	# Configurar estado inicial da máquina de suco
	var machine_label = puzzle_trigger.get_node("Label")
	if GameManager.is_puzzle_solved("receita_proporcao"):
		machine_label.text = "SUCO\nOK"
		machine_label.add_theme_color_override("font_color", Color("#51CF66")) # Verde
	else:
		machine_label.text = "SUCO\nERRO"
		machine_label.add_theme_color_override("font_color", Color("#FF6B6B")) # Vermelho erro GDD


## Quando o jogador interage com um puzzle trigger
func _on_puzzle_triggered(puzzle_data: PuzzleData) -> void:
	puzzle_panel.open_puzzle(puzzle_data)


## Quando o jogador acerta o puzzle
func _on_puzzle_completed(puzzle_id: String) -> void:
	if puzzle_id == "receita_proporcao":
		hud.set_objective("Parabéns! Numerópolis está restaurada!")
		hud.show_byte_message("A máquina funcionou! Energia restaurada!", 5.0)
		byte_companion.show_message("Conseguimos! 🎉", 5.0)

		# Atualizar painel da máquina para OK em verde
		var machine_label = puzzle_trigger.get_node("Label")
		machine_label.text = "SUCO\nOK"
		machine_label.add_theme_color_override("font_color", Color("#51CF66"))

		# Verificar se atingiu 100%
		if GameManager.energy_level >= 1.0:
			_show_completion_message()


## Quando o jogador erra o puzzle
func _on_puzzle_error(error_count: int, puzzle_data: PuzzleData) -> void:
	byte_companion.show_error_reaction(error_count)
	hud.show_byte_message(byte_companion.get_hint(error_count, puzzle_data), 4.0)
	hud.show_hint_available(true)


## Quando o jogador pede dica ao Byte
func _on_hint_requested() -> void:
	if GameManager.current_puzzle_data:
		byte_companion.show_hint(GameManager.current_puzzle_errors, GameManager.current_puzzle_data)


## Mensagem de conclusão do protótipo
func _show_completion_message() -> void:
	await get_tree().create_timer(2.0).timeout
	DialogManager.start_dialog([
		{"speaker": "Byte", "text": "Léo, conseguimos! A energia de Numerópolis está em 100%!"},
		{"speaker": "Byte", "text": "O Sistema Central de Medidas está voltando ao normal."},
		{"speaker": "Byte", "text": "Obrigado por jogar o protótipo de Math Rescue! 🎮"}
	])
