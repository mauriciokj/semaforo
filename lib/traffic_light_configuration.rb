# frozen_string_literal: true

require_relative 'traffic_light_state'

module TrafficLight
  # Gerencia a configuração e os estados do semáforo
  #
  # O que foi feito:
  # - Definição dos três estados do semáforo com cores, mensagens e durações.
  # - Exposição dos estados e do estado inicial via métodos de classe.
  class TrafficLightConfiguration
    STATES = [
      TrafficLightState.new('vermelho', 'PARA!', 15),
      TrafficLightState.new('verde', 'SEGUE AI', 10),
      TrafficLightState.new('amarelo', 'FICA LIGADO!', 5)
    ].freeze

    # Retorna a lista de estados configurados
    def self.states
      STATES
    end

    # Retorna o estado inicial (vermelho)
    def self.initial_state
      STATES.first
    end
  end
end