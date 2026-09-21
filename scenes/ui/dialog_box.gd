## Caixa de diálogo estilo balão de fala flutuante.
## Segue e se posiciona acima do personagem ou NPC falante na tela.
extends CanvasLayer

@onready var panel: PanelContainer = $Control/Panel
@onready var speaker_label: Label = $Control/Panel/MarginContainer/VBox/SpeakerLabel
@onready var text_label: RichTextLabel = $Control/Panel/MarginContainer/VBox/TextLabel
@onready var typewriter_timer: Timer = $TypewriterTimer

var full_text: String = ""
var current_char_index: int = 0
var is_typing: bool = false
var typewriter_speed: float = 0.03

## Referência ao nó falante ativo no mundo
var active_speaker_node: Node2D = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false

	typewriter_timer.timeout.connect(_on_typewriter_tick)
	DialogManager.dialog_line_requested.connect(_on_dialog_line_requested)
	DialogManager.dialog_finished.connect(_on_dialog_finished)


func _process(_delta: float) -> void:
	if panel.visible:
		_update_bubble_position()


## Atualiza a posição do balão na tela baseado no falante
func _update_bubble_position() -> void:
	var target_node = active_speaker_node

	# Se não tiver falante definido, tenta buscar o Léo ou o Byte
	if target_node == null:
		if speaker_label.text.begins_with("Byte"):
			target_node = GameManager.byte_companion
		else:
			target_node = GameManager.player

	if is_instance_valid(target_node):
		var screen_pos = target_node.get_global_transform_with_canvas().origin
		# Posiciona o balão centralizado acima do personagem (-50px de offset y)
		var target_pos = screen_pos + Vector2(-panel.size.x / 2, -panel.size.y - 30)
		
		# Limitar para não sair das bordas da tela
		var viewport_size = get_viewport().get_visible_rect().size
		target_pos.x = clampf(target_pos.x, 10.0, viewport_size.x - panel.size.x - 10.0)
		target_pos.y = clampf(target_pos.y, 10.0, viewport_size.y - panel.size.y - 10.0)
		
		panel.global_position = target_pos
	else:
		# Posição de fallback centralizada na base
		var viewport_size = get_viewport().get_visible_rect().size
		panel.global_position = Vector2((viewport_size.x - panel.size.x) / 2, viewport_size.y - panel.size.y - 50)


func _input(event: InputEvent) -> void:
	if not panel.visible:
		return

	if event.is_action_pressed("interact"):
		if is_typing:
			skip_typewriter()
		else:
			DialogManager.advance_dialog()


## Mostra uma linha de diálogo
func show_dialog(speaker: String, text: String) -> void:
	# Tentar determinar qual nó está falando
	_find_speaker_node(speaker)

	speaker_label.text = speaker + ":"
	full_text = text
	current_char_index = 0
	text_label.text = ""
	is_typing = true
	panel.visible = true

	# Forçar atualização de tamanho para centralizar corretamente no próximo frame
	panel.reset_size()

	typewriter_timer.wait_time = typewriter_speed
	typewriter_timer.start()


## Procura o nó no cenário que corresponde ao nome de quem fala
func _find_speaker_node(speaker_name: String) -> void:
	active_speaker_node = null
	
	if speaker_name == "Byte":
		active_speaker_node = GameManager.byte_companion
		return
	elif speaker_name == "Léo" or speaker_name == "Leo":
		active_speaker_node = GameManager.player
		return

	# Caso seja um NPC ou placa, tenta encontrar o interactable atual do Léo
	if GameManager.player and is_instance_valid(GameManager.player.nearest_interactable):
		active_speaker_node = GameManager.player.nearest_interactable


## Tick do typewriter
func _on_typewriter_tick() -> void:
	if current_char_index < full_text.length():
		current_char_index += 1
		text_label.text = full_text.substr(0, current_char_index)
	else:
		is_typing = false
		typewriter_timer.stop()


## Pula o typewriter
func skip_typewriter() -> void:
	text_label.text = full_text
	current_char_index = full_text.length()
	is_typing = false
	typewriter_timer.stop()


## Esconde o balão
func hide_dialog() -> void:
	panel.visible = false
	active_speaker_node = null


func _on_dialog_line_requested(speaker: String, text: String) -> void:
	show_dialog(speaker, text)


func _on_dialog_finished() -> void:
	hide_dialog()
