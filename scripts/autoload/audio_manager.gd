## Gerenciador de Áudio Sintético (Autoload Singleton).
## Gera efeitos sonoros em tempo real (sem precisar de arquivos .wav/.mp3).
extends Node

var audio_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)


## Toca o som de Acerto ("ding" eletrônico)
func play_success() -> void:
	_play_synth_beep(880.0, 0.1, 0.8) # Nota La (A5)
	await get_tree().create_timer(0.08).timeout
	_play_synth_beep(1318.51, 0.25, 0.8) # Nota Mi (E6)


## Toca o som de Erro (neutro e curto)
func play_error() -> void:
	_play_synth_beep(180.0, 0.15, 0.7, true) # Onda quadrada de tom baixo


## Toca o som de Porta Abrindo (mecânico)
func play_door_open() -> void:
	# Simula um barulho mecânico gerando uma sequência de cliques
	for i in range(12):
		_play_synth_beep(200.0 - (i * 10), 0.03, 0.4)
		await get_tree().create_timer(0.04).timeout


## Toca o som do Byte (bipe curto antes de falar)
func play_byte_beep() -> void:
	_play_synth_beep(987.77, 0.06, 0.5) # Nota Si (B5)
	await get_tree().create_timer(0.04).timeout
	_play_synth_beep(1174.66, 0.08, 0.5) # Nota Re (D6)


## Toca o som de Energia voltando (crescente)
func play_energy_up() -> void:
	for i in range(8):
		_play_synth_beep(440.0 + (i * 110), 0.05, 0.5)
		await get_tree().create_timer(0.06).timeout


## Função interna auxiliar que cria e reproduz ondas sonoras sintéticas
func _play_synth_beep(frequency: float, duration: float, volume: float, use_square_wave: bool = false) -> void:
	var sample_rate = 44100.0
	var playback_length = int(sample_rate * duration)
	var audio_stream = AudioStreamWAV.new()
	
	audio_stream.format = AudioStreamWAV.FORMAT_8_BITS
	audio_stream.mix_rate = int(sample_rate)
	
	var data = PackedByteArray()
	data.resize(playback_length)
	
	for i in range(playback_length):
		var t = float(i) / sample_rate
		var val = 0.0
		
		# Onda senoidal ou quadrada
		if use_square_wave:
			val = 1.0 if sin(2.0 * PI * frequency * t) >= 0 else -1.0
		else:
			val = sin(2.0 * PI * frequency * t)
			
		# Aplicar fade out linear para evitar estalos no final do som
		var fade = 1.0 - (float(i) / playback_length)
		val *= fade * volume
		
		# Converter de float [-1.0, 1.0] para byte [0, 255]
		var byte_val = int((val + 1.0) * 127.0)
		data[i] = byte_val
		
	audio_stream.data = data
	
	# Criar um reprodutor temporário para tocar em paralelo
	var temp_player = AudioStreamPlayer.new()
	add_child(temp_player)
	temp_player.stream = audio_stream
	temp_player.volume_db = -10.0 # Ajuste fino do volume
	temp_player.play()
	
	# Limpar reprodutor quando acabar
	temp_player.finished.connect(temp_player.queue_free)
