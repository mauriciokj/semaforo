# Semáforo – Sistema de Controle de Trânsito (Ruby)

Projeto em Ruby que simula um semáforo com ciclo contínuo entre três estados: vermelho, verde e amarelo. O sistema foi estruturado com foco em separação de responsabilidades, testabilidade e princípios SOLID.

## Descrição do Projeto

- Ciclo do semáforo: `vermelho (15s) → verde (10s) → amarelo (5s)` e repete.
- Para cada estado, o sistema exibe uma mensagem no `stdout`:
  - Vermelho: `PARA!`
  - Verde: `SEGUE AI`
  - Amarelo: `FICA LIGADO!`
- Durante cada estado, a mensagem é exibida a cada 1 segundo, pelo total da duração do estado (ex.: vermelho imprime 15 vezes, verde 10, amarelo 5).
- O ciclo pode ser iniciado e interrompido com segurança.

## Requisitos

- `Ruby 3.3.6`
- Gems de desenvolvimento/testes:
  - `rspec (~> 3.13)`
  - `simplecov (~> 0.22)`
  - `rubocop (~> 1.69)`
  - `rubocop-rspec (~> 3.2)`

Veja o `Gemfile` para a lista completa de dependências.

## Instalação

1. Garanta que você tenha Ruby `3.3.6` instalado.
2. Instale as dependências:

   ```bash
   bundle install
   ```

## Execução

Para executar o semáforo na linha de comando:

```bash
ruby semaforo.rb
```

Saída esperada (exemplo):

```
Iniciando semáforo...
PARA!
SEGUE AI
FICA LIGADO!
... (repete)
```

Para encerrar, pressione `Ctrl + C`. O aplicativo trata o sinal e realiza parada graciosa.

## Estrutura do Projeto

```
semaforo/
├── semaforo.rb                # Runner da aplicação
├── lib/
│   ├── traffic_light_state.rb         # Modelo de estado do semáforo
│   ├── traffic_light_configuration.rb # Configuração dos estados e inicial
│   ├── traffic_light.rb               # Lógica do semáforo e transições
│   └── traffic_light_controller.rb    # Controle do ciclo e temporização
└── spec/                      # Testes RSpec
```

### Classes e Responsabilidades

- `TrafficLightState`
  - Representa um estado do semáforo com `color`, `message` e `duration`.
  - Fornece `to_s` e comparação de igualdade.

- `TrafficLightConfiguration`
  - Define os estados (`vermelho`, `verde`, `amarelo`) e o estado inicial.
  - Centraliza configuração para facilitar ajustes futuros.

- `TrafficLight`
  - Gerencia o estado atual e as transições (`next_state`).
  - Expõe `current_message`, `current_duration` e `current_color`.
  - Permite `reset` para voltar ao estado inicial.

- `TrafficLightController`
  - Controla o loop de execução (`start`, `stop`).
  - Exibe mensagens (`display_current_state`) e respeita a duração com `sleep`.
  - Injeta `output` (padrão `stdout`) para facilitar testes.

- `semaforo.rb`
  - Runner da aplicação: inicia o controller, trata `SIGINT` e inicia o ciclo.

## Princípios SOLID Aplicados

- **Single Responsibility**: cada classe tem responsabilidade clara e única
  - `TrafficLightState`: representa um estado (Value Object)
  - `TrafficLightConfiguration`: gerencia configuração
  - `TrafficLight`: gerencia transições de estado
  - `TrafficLightController`: controla temporização e I/O
- **Open/Closed**: novas configurações/estados podem ser adicionadas sem modificar classes centrais
- **Liskov Substitution**: componentes podem ser substituídos por mocks/stubs nos testes
- **Interface Segregation**: métodos públicos enxutos e específicos por classe
- **Dependency Inversion**: `TrafficLightController` depende de abstrações (traffic_light, output)

## Padrões de Design

- **Value Object**: `TrafficLightState` é imutável e comparável por valor
- **State Pattern**: `TrafficLight` gerencia transições entre estados
- **Dependency Injection**: facilita testes e substituição de componentes
- **Delegation**: uso de `Forwardable` para evitar código repetitivo

## Testes

Rodar todos os testes:

```bash
bundle exec rspec
```

Cobertura de testes é medida com `SimpleCov`. O relatório é gerado em `coverage/index.html`.

### Cobertura Atual
- ✅ **100%** de cobertura em todos os arquivos de `lib/`
- ✅ **60+ testes** cobrindo todas as funcionalidades
- ✅ Testes de validação, imutabilidade e edge cases

### Ver Relatório de Cobertura
```bash
open coverage/index.html
```

## Exemplos de Uso (Código)

```ruby
require_relative 'lib/traffic_light_controller'

controller = TrafficLight::TrafficLightController.new
trap('INT') { controller.stop }
controller.start
```

## Mensagens e Durações por Cor

- Vermelho: mensagem `PARA!`, duração `15s`
- Verde: mensagem `SEGUE AI`, duração `10s`
- Amarelo: mensagem `FICA LIGADO!`, duração `5s`

## Melhorias Recentes

Veja o arquivo [IMPROVEMENTS.md](IMPROVEMENTS.md) para detalhes completos sobre as melhorias implementadas.

### Destaques
- ✅ **Value Object Pattern** em `TrafficLightState` com imutabilidade
- ✅ **Validações** robustas de parâmetros
- ✅ **Delegação** com `Forwardable` para código mais limpo
- ✅ **Extração de métodos** para melhor legibilidade
- ✅ **Constantes** em vez de magic numbers
- ✅ **100% de cobertura** de testes

## Como Contribuir

- Execute RuboCop para garantir estilo consistente:

  ```bash
  bundle exec rubocop
  ```

- Rode os testes antes de abrir PRs.
- Mantenha comentários e documentação sincronizados com o código.
- Siga os princípios SOLID e padrões de design estabelecidos.

## Licença

Projeto para fins educacionais/demonstração. Licença livre para uso e modificação.