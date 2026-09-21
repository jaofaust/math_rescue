# MR — Math Rescue
# PLANO DE GERENCIAMENTO DE CONFIGURAÇÃO
### Enfoque DevOps — Integração e Entrega Contínuas (CI/CD)
**Versão 1.0**

| Campo | Descrição |
| :--- | :--- |
| **Projeto** | MR — Math Rescue |
| **Gerente de Projeto** | João Pedro Faust |
| **Gerente/Responsável de GCS-DevOps** | João Pedro Faust |
| **Fábrica de Software / Squad** | Squad Math Rescue — Engenharia de Software (3ª Fase) |
| **Repositório principal** | https://github.com/jaofaust/math_rescue.git |

### Histórico de Revisões
| Data | Versão | Descrição | Autor |
| :--- | :--- | :--- | :--- |
| 21/09/2026 | 1.0 | Elaboração inicial do PGC adaptado ao jogo Math Rescue com práticas DevOps (CI/CD, versionamento semântico e pipelines de exportação Godot). | João Pedro Faust |

---

## 1. Introdução

Este Plano de Gerenciamento de Configuração (PGC) descreve as atividades de Gestão de Configuração de Software (GCS) executadas ao longo do ciclo de vida do jogo **Math Rescue**, com ênfase nas práticas modernas de DevOps — abrangendo Controle de Versão, Integração Contínua (CI), Entrega Contínua (CD) e automação de empacotamento. O objetivo é manter a integridade de todos os artefatos (código GDScript, cenas, recursos e documentação) com rastreabilidade completa e mínima sobrecarga manual.

### 1.1 Finalidade
Estabelecer as diretrizes e padrões de versionamento, automação e controle de mudanças para o desenvolvimento do jogo **Math Rescue**, garantindo que as builds para desktop (Windows) e web sejam reproduzíveis, testáveis e entregues de maneira confiável a cada iteração avaliativa (N1 e N2).

### 1.2 Escopo
Este PGC é destinado aos integrantes da equipe de desenvolvimento do projeto acadêmico **Math Rescue** (jogo educativo 2D em Godot 4), cobrindo:
- O código-fonte em GDScript e as cenas da engine Godot 4.
- Os recursos matemáticos e dados de puzzles (`.tres`).
- Pipelines de validação, empacotamento e entrega automatizados via GitHub Actions.
- Documentos de engenharia e manuais de reconstrução associados.

### 1.3 Definições, Acrônimos e Abreviações
| Termo | Significado |
| :--- | :--- |
| **GCS** | Gestão de Configuração de Software |
| **CI** | Integração Contínua (*Continuous Integration*) |
| **CD** | Entrega/Implantação Contínua (*Continuous Delivery / Deployment*) |
| **GDD** | *Game Design Document* (Documento de Design de Jogo) |
| **PR** | *Pull Request* |
| **SemVer** | Versionamento Semântico (`MAJOR.MINOR.PATCH`) |
| **Baseline** | Linha de base estável do projeto (ex.: versão homologada para entrega N1/N2) |
| **GUT** | *Godot Unit Test* (Framework de testes unitários para GDScript) |

### 1.4 Referências
- *Game Design Document* (GDD) — Math Rescue (PAC III / Engenharia de Software).
- Documentação Oficial da Godot Engine 4.x (`docs.godotengine.org`).
- *Pro Git Book* (Chacon & Straub) e boas práticas de Conventional Commits.
- Template RUP 7.0 (IBM) adaptado para abordagem ágil/DevOps.

---

## 2. Cultura DevOps e Papéis na Gerência de Configuração

| Papel | Responsabilidades no Projeto Math Rescue |
| :--- | :--- |
| **Product Owner / Líder de Projeto** | Prioriza os requisitos do GDD, valida os critérios de aceitação dos puzzles e aprova as entregas formais de cada marco (N1 e N2). |
| **DevOps / Release Engineer** | Mantém a infraestrutura do repositório no GitHub, configura os scripts de CI/CD no GitHub Actions, gera as releases executáveis e empacota os ZIPs de entrega. |
| **Desenvolvedor(a) Godot** | Implementa mecânicas, cenas (`.tscn`), scripts (`.gd`) e shaders; segue as convenções de commits, abre Pull Requests e mantém o código livre de avisos de compilação. |
| **QA / Testador(a) de Gameplay** | Valida a progressão do jogo (loop principal), confere consistência matemática dos puzzles, testa limites de colisão e reporta bugs via GitHub Issues. |
| **Comitê de Controle de Mudanças (CCM)** | Composto pela equipe do projeto. Avalia mudanças de escopo (ex.: corte ou adição de novas fases/bairros de Numerópolis). |

---

## 3. Ferramentas, Ambientes e Infraestrutura

### 3.1 Ferramentas do Pipeline
| Categoria | Ferramenta Adotada | Finalidade |
| :--- | :--- | :--- |
| **Controle de Versão** | Git + GitHub | Versionamento distribuído do código-fonte, cenas e documentação. |
| **Orquestração de CI/CD** | GitHub Actions | Validação sintática do GDScript, execução de testes e build automatizado. |
| **Engine / Build System** | Godot Engine 4.x (Modo Headless) | Compilação e exportação multiplataforma do jogo via linha de comando. |
| **Registro de Artefatos** | GitHub Releases & Artifacts | Armazenamento de binários executáveis (`.exe`, `.zip`) e pacotes da entrega. |
| **Rastreamento de Tarefas** | GitHub Issues / Projects | Gerenciamento de backlog, tarefas de desenvolvimento e correção de bugs. |

### 3.2 Ambientes e Infraestrutura
| Ambiente | Finalidade | Gatilho de Promoção |
| :--- | :--- | :--- |
| **Desenvolvimento Local** | Estação de trabalho dos desenvolvedores com Godot 4.x instalado. | Alteração no código local. |
| **Homologação (Staging)** | Build Web (HTML5) ou executável gerado automaticamente pelo GitHub Actions para testes internos da equipe. | *Push* ou *Merge* na branch `main`. |
| **Produção / Entrega** | Versão empacotada (.zip / executável para Windows) disponibilizada nas GitHub Releases para avaliação do professor. | Criação de tag de release (ex.: `v1.0.0-N1`). |

### 3.3 Estratégia de Branching e Versionamento
- **Estratégia Adotada:** **GitHub Flow / Trunk-Based Development** simplificado.
  - `main`: Branch principal, sempre em estado estável e jogável.
  - `feature/<nome-da-feature>`: Branches de curta duração criadas a partir da `main` (ex.: `feature/puzzle-mercado`, `feature/audio-sintetico`).
  - `fix/<nome-do-bug>`: Correções pontuais de bugs de gameplay ou colisão.
- **Padrão de Commits:** *Conventional Commits*:
  - `feat:` Nova mecânica ou puzzle (ex.: `feat: adiciona feedback sonoro no puzzle da porta`).
  - `fix:` Correção de bug (ex.: `fix: ajusta filtro de clique no painel de puzzle`).
  - `docs:` Alterações de documentação ou GDD.
  - `refactor:` Melhoria de código sem alteração funcional.
- **Versionamento:** SemVer (`MAJOR.MINOR.PATCH`):
  - `v1.0.0-N1`: Entrega do protótipo funcional para a avaliação N1 (Praça Central e Mercado).
  - `v2.0.0-N2`: Versão completa expandida prevista para a avaliação N2.

---

## 4. Identificação da Configuração

### 4.1 Itens de Configuração (ICs)
1. **Código e Cenas Godot:**
   - Scripts da engine (`/scripts/autoload/`, `/scripts/resources/`).
   - Cenas de níveis, personagens e interface (`/scenes/levels/`, `/scenes/characters/`, `/scenes/ui/`).
   - Arquivo central de configuração da engine: `project.godot`.
2. **Dados de Puzzles:**
   - Recursos customizados Godot (`/resources/puzzles/*.tres`).
3. **Automação e DevOps:**
   - Workflows do pipeline (`.github/workflows/*.yml`).
   - Arquivos de configuração de versionamento (`.gitignore`, `.gitattributes`, `.editorconfig`).
4. **Documentação Técnica:**
   - *Manual de Reconstrução do Ambiente* (`MANUAL_RECONSTRUCAO.md`).
   - *Plano de Gerenciamento de Configuração* (este documento).
   - *Game Design Document* (GDD do Math Rescue).

### 4.2 Convenção de Nomenclatura
| Item | Convenção | Exemplo |
| :--- | :--- | :--- |
| **Branch** | `<tipo>/<descricao-curta>` | `feature/dicas-byte`, `fix/colisao-parede` |
| **Commit** | `<tipo>(<escopo>): <descricao>` | `feat(puzzle): implementa calculo de proporcao de suco` |
| **Tag / Release** | `v<Major>.<Minor>.<Patch>[-etapa]` | `v1.0.0-N1`, `v1.1.0` |
| **Artefato Final** | `math_rescue_<plataforma>_<versao>.zip` | `math_rescue_windows_v1.0.0.zip` |

### 4.3 Estrutura do Repositório
```text
math-rescue/
├── .github/
│   └── workflows/                # Pipelines de CI/CD (GitHub Actions)
├── assets/                       # Sprites, áudios e recursos visuais
├── docs/                         # Documentação técnica e PGC
├── resources/
│   └── puzzles/                  # Instâncias de PuzzleData (.tres)
├── scenes/
│   ├── characters/               # Cenas e scripts do Léo, Byte e NPCs
│   ├── levels/                   # Cenas das fases (Praça Central, Sala Mercado)
│   ├── objects/                  # Portas, painéis e elementos interativos
│   └── ui/                       # HUD, PuzzlePanel, Diálogos e Menu de Pausa
├── scripts/
│   ├── autoload/                 # Singletons globais (GameManager, AudioManager, etc.)
│   └── resources/                # Definição de classes de recursos (PuzzleData.gd)
├── .editorconfig                 # Padrões de formatação de código
├── .gitignore                    # Ignora cache (.godot/) e arquivos temporários
├── icon.svg                      # Ícone do projeto
└── project.godot                 # Configuração principal da engine Godot 4
```

---

## 5. Integração Contínua (CI)

### 5.1 Etapas do Pipeline de CI
A cada abertura ou atualização de Pull Request para a branch `main`:
1. **Checkout:** Download do repositório no agente virtual (Ubuntu runner).
2. **Instalação do Godot:** Download e configuração do binário *Godot 4 Headless*.
3. **Análise Estática (Linting):** Validação de sintaxe e conformidade dos arquivos `.gd` (verificação de tipagem e erros de compilação).
4. **Validação de Cenas e Recursos:** Checagem de integridade dos arquivos `.tscn` e `.tres` para garantir que não há dependências quebradas ou nós faltantes.
5. **Verificação de Build:** Execução do comando de export headless para validar que o projeto compila sem erros críticos.

### 5.2 Política de Pull Request e Revisão de Código
- Todo código novo deve ser submetido via Pull Request para a branch `main`.
- O PR deve conter uma descrição concisa do que foi implementado/corrigido.
- É exigida aprovação por pelo menos um membro da squad antes do *merge*.
- Merge bloqueado caso o pipeline de CI acuse falhas.

### 5.3 Critérios de Qualidade (Quality Gate)
- **Zero erros de compilação** no Godot 4.
- **Zero UIDs inválidos** ou dependências ausentes nas cenas.
- Todos os arquivos temporários da engine (`.godot/`) devidamente ignorados pelo `.gitignore`.

---

## 6. Entrega e Implantação Contínua (CD)

### 6.1 Etapas do Pipeline de CD
Ao realizar o *merge* na branch `main` ou ao publicar uma nova tag de versão:
1. O pipeline de CD exporta o jogo para o formato executável Windows Desktop (`.exe` + `.pck`).
2. Compacta a compilação gerando o arquivo `math_rescue_windows.zip`.
3. Anexa o arquivo compactado automaticamente na aba de **Releases** do GitHub associado à tag criada.

### 6.2 Estratégias de Implantação
- **Entrega Baseada em Releases (Artifact Delivery):** Os pacotes executáveis são versionados e disponibilizados para download direto no GitHub, permitindo que professores e testadores baixem a versão estável correspondente a cada marco avaliativo sem precisar abrir a engine.

### 6.3 Rollback e Recuperação
Como o projeto utiliza Git com versionamento semântico:
- Caso uma release apresente falha crítica, a equipe pode realizar um `git revert` do commit causador ou redistribuir o artefato da tag anterior (que permanece arquivado no histórico de Releases do GitHub).

---

## 7. Infraestrutura como Código (IaC) e Ambientes

- **Ambiente de Build Padronizado:** O ambiente de integração contínua é configurado via código declarativo em arquivos YAML (`.github/workflows/`), utilizando imagens Linux padronizadas com o Godot Engine oficial, garantindo que o build funcione igualmente no computador de qualquer membro da equipe ou no servidor.

---

## 8. Controle de Configuração e Mudança

### 8.1 Processo de Solicitação de Mudança
1. **Identificação:** Criação de uma *Issue* no GitHub detalhando a necessidade de melhoria ou o bug encontrado.
2. **Desenvolvimento:** Criação da branch a partir da `main` (`feature/` ou `fix/`).
3. **Validação:** Submissão do Pull Request e execução do pipeline de CI.
4. **Integração:** Revisão por pares, aprovação e *Squash and Merge* na `main`.

### 8.2 Comitê de Controle de Mudanças (CCM)
O comitê é composto pelos desenvolvedores da squad Math Rescue. Decisões estruturais (como alterações drásticas na lógica de progressão dos puzzles ou inclusão de novos sistemas não previstos no GDD original) devem ser acordadas coletivamente antes do início da implementação.

---

## 9. Baselines e Releases

### 9.1 Geração Automática de Baseline
Cada tag Git criada marca formalmente uma baseline do projeto:
- **Baseline N1 (`v1.0.0-N1`):** Protótipo inicial jogável contendo o core loop de movimentação do Léo, robô Byte, Praça Central (puzzle de conversão 2m $\rightarrow$ 200cm), Porta Interativa e Sala do Mercado (puzzle de proporção com Dona Mira e máquina de suco).
- **Baseline N2 (`v2.0.0-N2`):** Versão final expandida do jogo.

### 9.2 Notas de Versão (Release Notes)
As notas de versão acompanham cada release no GitHub, listando:
- Principais funcionalidades adicionadas.
- Puzzles implementados e validados.
- Correções de bugs de jogabilidade e melhorias visuais/sonoras.

---

## 10. Estimativa do Status de Configuração

### 10.1 Monitoramento e Auditoria
O histórico completo de commits, pull requests fechados e logs de execução do GitHub Actions formam o registro de auditoria contínua do projeto.

### 10.2 Métricas DORA (Contexto do Projeto)
| Métrica | Meta / Aplicação no Projeto |
| :--- | :--- |
| **Deployment Frequency** | Pelo menos 1 a 2 builds funcionais por semana geradas pela equipe. |
| **Lead Time for Changes** | Tempo médio de 24h a 48h entre a abertura de uma branch de puzzle e sua integração à `main`. |
| **Change Failure Rate** | Inferior a 15% de falhas nos pipelines de CI após submissão de PR. |
| **MTTR (Tempo de Recuperação)** | Correção imediata de bugs impeditivos em menos de 2 horas via *hotfix*. |

---

## 11. Marcos (Milestones)

| Marco | Prazo Estimado | Entregáveis de GCS/DevOps |
| :--- | :--- | :--- |
| **M1: Inicialização** | Agosto/2026 | Repositório criado no GitHub, `.gitignore` configurado e estrutura de pastas validada. |
| **M2: Automação CI** | Setembro/2026 | Configuração do GitHub Actions para validação e exportação. |
| **M3: Baseline N1** | Setembro/2026 | Tag `v1.0.0-N1`, release gerada, código-fonte e Manual de Reconstrução consolidados. |
| **M4: Expansão N2** | Novembro/2026 | Tag final `v2.0.0-N2` com áreas adicionais de Numerópolis empacotadas. |

---

## 12. Treinamento e Recursos

- **Ferramental Básico:** Git instalado na versão 2.40+, Godot Engine versão 4.2+ (Standard Edition).
- **Alinhamento da Equipe:** Guia prático de comandos Git (`clone`, `checkout -b`, `commit`, `push`) e manual de importação do projeto no Godot.

---

## 13. Controle de Dependências de Terceiros

- **Engine:** Godot Engine 4.x (versão oficial livre e de código aberto sob licença MIT).
- **Assets de Áudio:** Gerador sintético interno em tempo real (`audio_manager.gd`) e áudios com licença Creative Commons (Freesound.org).
- **Controle:** Nenhuma dependência binária externa pesada é armazenada fora do repositório; os templates de exportação necessários são descritos no Manual de Reconstrução.

---

## 14. Quadro-Resumo do Pipeline CI/CD

| Etapa | Descrição | Gatilho |
| :--- | :--- | :--- |
| **CI — Validação** | Checagem estática de scripts GDScript, validação das cenas `.tscn` e do arquivo `project.godot`. | Abertura ou atualização de Pull Request. |
| **Merge** | Integração da funcionalidade validada na branch principal `main`. | Aprovação de PR + CI com status verde. |
| **CD — Staging** | Exportação automática para build web / testes locais da equipe. | *Push* na branch `main`. |
| **CD — Release** | Geração do pacote compactado `.zip` para Windows e criação da Release oficial com notas de versão. | Criação de Tag Git (ex.: `v1.0.0-N1`). |
