## Recurso customizado para definir dados de um puzzle.
## Cada puzzle do jogo é uma instância desse Resource.
class_name PuzzleData
extends Resource

## Identificador único do puzzle (ex: "porta_unidades")
@export var puzzle_id: String

## Texto de contexto que aparece no topo do painel
@export_multiline var context_text: String

## Pergunta que o jogador precisa responder
@export var question: String

## Lista de opções de resposta
@export var options: PackedStringArray

## Índice da resposta correta (começa em 0)
@export var correct_index: int

## Dica nível 1: lembra o conceito (ex: "1 metro tem 100 centímetros")
@export_multiline var hint_concept: String

## Dica nível 2: aponta a pista no cenário
@export_multiline var hint_clue: String

## Dica nível 3: simplifica o raciocínio passo a passo
@export_multiline var hint_reasoning: String

## Mensagem exibida ao acertar
@export var success_message: String

## Quanto de energia adiciona na barra de Numerópolis (0.0 a 1.0)
@export var energy_reward: float = 0.5
