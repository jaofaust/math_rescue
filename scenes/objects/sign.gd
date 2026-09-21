## Placa interativa simples que mostra um texto quando interagida.
extends Node2D

@export_multiline var sign_text: String = "Texto da placa"
@export var sign_name: String = "Placa"
@export var interaction_prompt: String = "Pressione E para ler"


func interact() -> void:
	DialogManager.show_line(sign_name, sign_text)


func get_interaction_prompt() -> String:
	return interaction_prompt
