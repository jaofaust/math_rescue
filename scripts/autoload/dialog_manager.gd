## Gerenciador de diálogos (Autoload Singleton).
## Controla a fila de diálogos e comunicação com a caixa de diálogo.
extends Node

## --- Sinais ---
signal dialog_started
signal dialog_finished
signal dialog_line_requested(speaker: String, text: String)

## --- Estado ---
var dialog_queue: Array = []  # Array de {speaker: String, text: String}
var is_dialog_active: bool = false
var current_line_index: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## Inicia uma sequência de diálogos.
## [param lines] Array de dicionários com "speaker" e "text".
func start_dialog(lines: Array) -> void:
	if lines.is_empty():
		return

	dialog_queue = lines
	current_line_index = 0
	is_dialog_active = true

	GameManager.set_state(GameManager.GameState.DIALOG)
	dialog_started.emit()
	_show_current_line()


## Mostra uma única linha de diálogo imediatamente.
func show_line(speaker: String, text: String) -> void:
	start_dialog([{"speaker": speaker, "text": text}])


## Avança para a próxima linha de diálogo ou finaliza.
func advance_dialog() -> void:
	current_line_index += 1

	if current_line_index < dialog_queue.size():
		_show_current_line()
	else:
		end_dialog()


## Finaliza o diálogo atual.
func end_dialog() -> void:
	is_dialog_active = false
	dialog_queue.clear()
	current_line_index = 0

	if GameManager.current_state == GameManager.GameState.DIALOG:
		GameManager.set_state(GameManager.GameState.EXPLORING)

	dialog_finished.emit()


## Atalho para mostrar uma mensagem do Byte.
func show_byte_message(text: String) -> void:
	show_line("Byte", text)


## Mostra a linha atual da fila.
func _show_current_line() -> void:
	if current_line_index < dialog_queue.size():
		var line = dialog_queue[current_line_index]
		if line["speaker"] == "Byte":
			AudioManager.play_byte_beep()
		dialog_line_requested.emit(line["speaker"], line["text"])
