## Script do personagem jogável Léo.
## Movimentação 2D com WASD/setas, interação com E, pedido de dica com H.
extends CharacterBody2D

@export var speed: float = 200.0

## Direção atual do personagem (usada para orientar a zona de interação)
var current_direction: Vector2 = Vector2.DOWN
var nearest_interactable: Node = null

@onready var interaction_zone: Area2D = $InteractionZone
@onready var body: ColorRect = $Body
@onready var head: Panel = $Head
@onready var camera_2d: Camera2D = $Camera2D

signal hint_requested


func _ready() -> void:
	interaction_zone.area_entered.connect(_on_interaction_zone_area_entered)
	interaction_zone.area_exited.connect(_on_interaction_zone_area_exited)


func _physics_process(delta: float) -> void:
	if GameManager.current_state != GameManager.GameState.EXPLORING:
		velocity = Vector2.ZERO
		return

	# Captura input de movimento
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed

	if input_dir != Vector2.ZERO:
		current_direction = input_dir.normalized()
		_update_interaction_zone_position()

	move_and_slide()


func _input(event: InputEvent) -> void:
	# Interação com E
	if event.is_action_pressed("interact"):
		if GameManager.current_state == GameManager.GameState.EXPLORING:
			_try_interact()

	# Pedido de dica com H
	if event.is_action_pressed("hint"):
		if GameManager.current_puzzle_errors >= 1:
			hint_requested.emit()


## Tenta interagir com o objeto mais próximo na zona de interação
func _try_interact() -> void:
	if nearest_interactable and nearest_interactable.has_method("interact"):
		nearest_interactable.interact()


## Atualiza a posição da zona de interação baseada na direção
func _update_interaction_zone_position() -> void:
	interaction_zone.position = current_direction * 24


## Quando um objeto entra na zona de interação
func _on_interaction_zone_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.has_method("interact"):
		nearest_interactable = parent
		if parent.has_method("get_interaction_prompt"):
			GameManager.show_interaction_prompt(parent.get_interaction_prompt())
		else:
			GameManager.show_interaction_prompt("Pressione E para interagir")


## Quando um objeto sai da zona de interação
func _on_interaction_zone_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent == nearest_interactable:
		nearest_interactable = null
		GameManager.hide_interaction_prompt()
