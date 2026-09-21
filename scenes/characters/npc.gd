## Script base para NPCs com diálogos.
## NPCs ficam parados no cenário e podem ser interagidos com E.
extends CharacterBody2D

@export var npc_name: String = "NPC"
@export var dialog_lines: PackedStringArray
@export var body_color: Color = Color("#D43B3B") # Padrão: Vermelho de Dona Mira

@onready var interaction_area: Area2D = $InteractionArea
@onready var body: ColorRect = $Body


func _ready() -> void:
	body.color = body_color


## Chamado quando o jogador interage com o NPC
func interact() -> void:
	if dialog_lines.is_empty():
		return

	var lines: Array = []
	for line in dialog_lines:
		lines.append({"speaker": npc_name, "text": line})

	DialogManager.start_dialog(lines)


## Retorna o texto do prompt de interação
func get_interaction_prompt() -> String:
	return "Pressione E para falar com " + npc_name
