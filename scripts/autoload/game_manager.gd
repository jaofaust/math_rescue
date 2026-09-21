## Gerenciador global do jogo (Autoload Singleton).
## Controla estado do jogo, progresso dos puzzles e barra de energia.
extends Node

## Estados possíveis do jogo
enum GameState {
	EXPLORING,  ## Jogador se movendo e explorando
	PUZZLE,     ## Painel de puzzle aberto
	DIALOG,     ## Diálogo em andamento
	PAUSED      ## Jogo pausado
}

## --- Sinais ---
signal puzzle_solved(puzzle_id: String)
signal energy_changed(new_value: float)
signal state_changed(new_state: GameState)
signal interaction_prompt_changed(text: String, is_visible: bool)
signal hint_requested_global(error_count: int)

## --- Estado do jogo ---
var current_state: GameState = GameState.EXPLORING
var previous_state: GameState = GameState.EXPLORING

## --- Progresso ---
var puzzles_solved: Dictionary = {}
var energy_level: float = 0.0
var current_puzzle_errors: int = 0
var current_puzzle_data: PuzzleData = null

## --- Referências ---
var player: CharacterBody2D = null
var byte_companion: CharacterBody2D = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_state == GameState.PAUSED:
			unpause_game()
		elif current_state == GameState.EXPLORING:
			pause_game()


## --- Gerenciamento de Estado ---

func set_state(new_state: GameState) -> void:
	previous_state = current_state
	current_state = new_state
	state_changed.emit(new_state)


func pause_game() -> void:
	set_state(GameState.PAUSED)
	get_tree().paused = true


func unpause_game() -> void:
	get_tree().paused = false
	set_state(previous_state)


## --- Puzzles ---

func solve_puzzle(puzzle_id: String, energy_reward: float) -> void:
	puzzles_solved[puzzle_id] = true
	add_energy(energy_reward)
	reset_puzzle_errors()
	puzzle_solved.emit(puzzle_id)


func is_puzzle_solved(puzzle_id: String) -> bool:
	return puzzles_solved.has(puzzle_id)


func reset_puzzle_errors() -> void:
	current_puzzle_errors = 0
	current_puzzle_data = null


func register_puzzle_error() -> void:
	current_puzzle_errors += 1


## --- Energia ---

func add_energy(amount: float) -> void:
	energy_level = clampf(energy_level + amount, 0.0, 1.0)
	energy_changed.emit(energy_level)


## --- Prompt de Interação ---

func show_interaction_prompt(text: String) -> void:
	interaction_prompt_changed.emit(text, true)


func hide_interaction_prompt() -> void:
	interaction_prompt_changed.emit("", false)
