# frozen_string_literal: true

require_relative 'traffic_light'

module TrafficLight
  # Controla a temporização e as transições do semáforo
  #
  # Melhorias implementadas:
  # - Lógica unificada para durações curtas e longas
  # - Garante ao menos 1 iteração para testes (durações < 1s)
  # - Métodos privados descritivos e coesos
  class TrafficLightController
    DISPLAY_INTERVAL = 1 # segundo
    
    def initialize(traffic_light = TrafficLight.new, output = $stdout)
      @traffic_light = traffic_light
      @output = output
      @running = false
    end

    # Inicia o ciclo do semáforo
    def start
      @running = true
      run_cycle
    end

    # Para o ciclo do semáforo
    def stop
      @running = false
    end

    # Indica se o ciclo está em execução
    def running?
      @running
    end

  private

  # Executa o ciclo enquanto estiver rodando
    def run_cycle
      while running?
        execute_current_state
        transition_to_next_state
      end
    end
    
    # Executa o estado atual pelo tempo configurado
    # Garante ao menos 1 iteração para durações < 1s (usado em testes)
    def execute_current_state
      duration = @traffic_light.current_duration
      total_seconds = [duration.to_i, 1].max
      sleep_time = duration / total_seconds
      
      total_seconds.times do
        break unless running?
        
        display_current_state
        sleep sleep_time
      end
    end
    
    # Faz a transição para o próximo estado se ainda estiver rodando
    def transition_to_next_state
      @traffic_light.next_state if running?
    end

    # Exibe a mensagem correspondente ao estado atual
    def display_current_state
      @output.puts @traffic_light.current_message
    end
  end
end