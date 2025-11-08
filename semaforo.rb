#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/traffic_light_controller'

# Runner principal da aplicação de semáforo
#
# O que foi feito:
# - Inicialização do controlador do semáforo.
# - Tratamento de `Ctrl + C` (SIGINT) para encerramento gracioso.
# - Mensagem de início e execução do ciclo.
module TrafficLight
  class Application
    def self.run
      controller = TrafficLightController.new
      
      # Handle graceful shutdown
      # Trata a interrupção do usuário para encerrar de forma segura
      trap('INT') do
        puts "\nEncerrando o semáforo..."
        controller.stop
        exit(0)
      end

      puts "Iniciando semáforo..."
      controller.start
    end
  end
end

# Run the application if this file is executed directly
# Executa a aplicação quando o arquivo é chamado diretamente
TrafficLight::Application.run if __FILE__ == $0