# frozen_string_literal: true

require_relative 'traffic_light'

module TrafficLight
  # Controla a temporização e as transições do semáforo
  #
  # Melhorias implementadas:
  # - Extração de métodos privados para melhor legibilidade
  # - Constante para intervalo de exibição
  # - Métodos mais descritivos e coesos
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
    def execute_current_state
      duration = @traffic_light.current_duration
      
      if short_duration?(duration)
        execute_short_duration(duration)
      else
        execute_normal_duration(duration)
      end
    end
    
    # Executa durações curtas (< 1s, usado em testes)
    def execute_short_duration(duration)
      display_current_state
      sleep duration
    end
    
    # Executa durações normais com exibição a cada segundo
    def execute_normal_duration(duration)
      total_seconds = duration.to_i
      
      total_seconds.times do
        break unless running?
        
        display_current_state
        sleep DISPLAY_INTERVAL
      end
    end
    
    # Verifica se a duração é curta (menor que o intervalo de exibição)
    def short_duration?(duration)
      duration && duration < DISPLAY_INTERVAL
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