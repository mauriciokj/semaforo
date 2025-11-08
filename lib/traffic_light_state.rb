# frozen_string_literal: true

module TrafficLight
  # Representa um único estado do semáforo (Value Object)
  #
  # Melhorias implementadas:
  # - Validação de parâmetros no initialize
  # - Imutabilidade com freeze
  # - Implementação de hash e eql? para uso em coleções
  # - Value Object pattern para garantir integridade
  class TrafficLightState
    attr_reader :color, :message, :duration

    def initialize(color, message, duration)
      validate_parameters!(color, message, duration)
      
      @color = color.to_s.freeze
      @message = message.to_s.freeze
      @duration = duration.to_f
      
      freeze # Torna o objeto imutável
    end

    # Retorna uma representação legível do estado
    def to_s
      "#{color.upcase}: #{message}"
    end

    # Compara estados por conteúdo (cor, mensagem e duração)
    def ==(other)
      return false unless other.is_a?(TrafficLightState)
      
      color == other.color &&
        message == other.message &&
        duration == other.duration
    end
    
    alias eql? ==
    
    # Hash para uso em coleções (Hash, Set)
    def hash
      [color, message, duration].hash
    end
    
    private
    
    # Valida os parâmetros de entrada
    def validate_parameters!(color, message, duration)
      raise ArgumentError, 'color cannot be nil or empty' if color.nil? || color.to_s.empty?
      raise ArgumentError, 'message cannot be nil or empty' if message.nil? || message.to_s.empty?
      raise ArgumentError, 'duration must be positive' unless duration.to_f.positive?
    end
  end
end