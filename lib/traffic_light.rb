# frozen_string_literal: true

require_relative 'traffic_light_state'
require_relative 'traffic_light_configuration'
require 'forwardable'

module TrafficLight
  # Classe principal do semáforo responsável por gerenciar transições de estado
  #
  # Melhorias implementadas:
  # - Delegação de métodos para evitar repetição
  # - Remoção de display_message (viola Single Responsibility)
  # - Método de consulta para verificar estado específico
  class TrafficLight
    extend Forwardable
    
    attr_reader :current_state, :states
    
    # Delega métodos para o estado atual
    def_delegators :@current_state, :color, :message, :duration

    def initialize(configuration = TrafficLightConfiguration)
      @configuration = configuration
      @states = configuration.states
      @current_state_index = 0
      @current_state = configuration.initial_state
    end

    # Avança para o próximo estado (ciclo contínuo)
    def next_state
      @current_state_index = next_index
      @current_state = @states[@current_state_index]
    end
    
    # Métodos de conveniência (mantidos para compatibilidade)
    alias current_message message
    alias current_duration duration
    alias current_color color
    
    # Verifica se está em um estado específico(Não usado em lugar nenhum no processo. 
    # Serve apenas para facilitar nos processos de testes)
    def in_state?(color_name)
      color == color_name.to_s
    end

    # Reinicia o semáforo para o estado inicial
    def reset
      @current_state_index = 0
      @current_state = @configuration.initial_state
    end
    
    private
    
    # Calcula o próximo índice no ciclo
    def next_index
      (@current_state_index + 1) % @states.length
    end
  end
end