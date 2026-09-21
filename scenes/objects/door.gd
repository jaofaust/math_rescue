## Porta que bloqueia a passagem até o puzzle associado ser resolvido.
## Quando resolvido, remove a colisão e faz animação de abertura.
extends StaticBody2D

@export var required_puzzle_id: String = ""

var is_open: bool = false

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect = $Visual
@onready var label: Label = $Label


func _ready() -> void:
	# Verificar se o puzzle já foi resolvido
	if not required_puzzle_id.is_empty() and GameManager.is_puzzle_solved(required_puzzle_id):
		_set_open_instantly()

	GameManager.puzzle_solved.connect(_on_puzzle_solved)


## Abre a porta com animação dramática
func open_door() -> void:
	if is_open:
		return

	is_open = true
	collision.set_deferred("disabled", true)
	AudioManager.play_door_open()

	# Animação: piscar verde → deslizar pra cima (fica visível em cima como portão aberto)
	var tween = create_tween()
	# Flash verde rápido
	tween.tween_property(visual, "color", Color(0.2, 1.0, 0.3, 1.0), 0.2)
	tween.tween_property(visual, "color", Color(0.3, 0.5, 0.3, 1.0), 0.2)
	tween.tween_interval(0.2)
	
	# Deslizar pra cima e diminuir opacidade de trancado
	tween.tween_property(visual, "position", visual.position + Vector2(0, -56), 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(label, "modulate", Color(0.2, 1.0, 0.3, 1.0), 0.3)
	tween.tween_callback(func(): label.text = "ABERTA")


## Já abre direto sem animação (para quando recarrega a cena)
func _set_open_instantly() -> void:
	is_open = true
	collision.set_deferred("disabled", true)
	visual.visible = false
	label.visible = false


## Quando um puzzle é resolvido
func _on_puzzle_solved(puzzle_id: String) -> void:
	if puzzle_id == required_puzzle_id:
		open_door()
