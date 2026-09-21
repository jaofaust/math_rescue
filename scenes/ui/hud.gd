## HUD do jogo — mostra objetivo, energia, prompt e mensagens do Byte.
extends CanvasLayer

@onready var objective_label: Label = $Control/TopBar/Margin/HBox/ObjectiveContainer/ObjectiveLabel
@onready var energy_bar: ProgressBar = $Control/TopBar/Margin/HBox/EnergyContainer/HBoxBar/EnergyBar
@onready var energy_label: Label = $Control/TopBar/Margin/HBox/EnergyContainer/HBoxBar/EnergyLabel
@onready var byte_message: Label = $Control/ByteMessage
@onready var interaction_prompt: Label = $Control/InteractionPrompt
@onready var hint_indicator: Label = $Control/HintIndicator
@onready var byte_timer: Timer = $ByteTimer


func _ready() -> void:
	# Conectar sinais do GameManager
	GameManager.energy_changed.connect(_on_energy_changed)
	GameManager.interaction_prompt_changed.connect(_on_interaction_prompt_changed)
	GameManager.state_changed.connect(_on_state_changed)

	byte_timer.timeout.connect(_on_byte_timer_timeout)
	byte_message.visible = false
	interaction_prompt.visible = false
	hint_indicator.visible = false

	update_energy(0.0)


func _process(_delta: float) -> void:
	if interaction_prompt.visible and GameManager.player:
		# Pegar posição do Léo na tela
		var player_pos = GameManager.player.get_global_transform_with_canvas().origin
		
		# Ajustar tamanho mínimo com base no texto para caber bonito
		var text_size = interaction_prompt.get_minimum_size()
		# Ajustar offset do tamanho para centralizar (offset Y de +30px abaixo dos pés do Léo)
		interaction_prompt.size = Vector2(text_size.x + 20, 26)
		interaction_prompt.global_position = player_pos + Vector2(-interaction_prompt.size.x / 2, 28)


## Atualiza o texto do objetivo
func set_objective(text: String) -> void:
	objective_label.text = text


## Atualiza a barra de energia
func update_energy(value: float) -> void:
	var new_value = value * 100.0
	if new_value > energy_bar.value:
		AudioManager.play_energy_up()
	energy_bar.value = new_value
	energy_label.text = "%d%%" % int(new_value)


## Mostra mensagem do Byte no HUD
func show_byte_message(text: String, duration: float = 3.0) -> void:
	byte_message.text = "🤖 Byte: " + text
	byte_message.visible = true
	byte_timer.wait_time = duration
	byte_timer.start()


## Mostra/esconde indicador de dica disponível
func show_hint_available(show: bool) -> void:
	hint_indicator.visible = show


## --- Callbacks de sinais ---

func _on_energy_changed(new_value: float) -> void:
	update_energy(new_value)


func _on_interaction_prompt_changed(text: String, is_visible: bool) -> void:
	interaction_prompt.text = text
	interaction_prompt.visible = is_visible


func _on_state_changed(new_state: GameManager.GameState) -> void:
	# Mostrar hint indicator apenas durante puzzle com erros
	if new_state == GameManager.GameState.PUZZLE and GameManager.current_puzzle_errors >= 1:
		hint_indicator.visible = true
	else:
		hint_indicator.visible = false


func _on_byte_timer_timeout() -> void:
	byte_message.visible = false
