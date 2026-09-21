## Classe base para objetos interativos no cenário.
## Detecta quando o jogador está por perto e pode ser interagido com E.
extends Area2D

@export var interaction_prompt: String = "Pressione E para interagir"

signal interacted


func _ready() -> void:
	# Configurar para ser detectável pela InteractionZone do Léo
	pass


## Chamado quando o jogador aperta E
func interact() -> void:
	interacted.emit()


## Retorna o texto do prompt
func get_interaction_prompt() -> String:
	return interaction_prompt
