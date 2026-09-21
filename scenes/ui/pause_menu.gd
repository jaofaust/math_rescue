## Menu de pausa — aparece ao apertar ESC.
extends CanvasLayer

@onready var control: Control = $Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	control.visible = false

	GameManager.state_changed.connect(_on_state_changed)


## Mostra o menu de pausa
func show_menu() -> void:
	control.visible = true


## Esconde o menu de pausa
func hide_menu() -> void:
	control.visible = false


## Botão Continuar
func _on_continue_pressed() -> void:
	GameManager.unpause_game()


## Botão Reiniciar
func _on_restart_pressed() -> void:
	GameManager.unpause_game()
	get_tree().reload_current_scene()


## Botão Sair
func _on_quit_pressed() -> void:
	get_tree().quit()


## Callback de mudança de estado
func _on_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.PAUSED:
		show_menu()
	else:
		hide_menu()
