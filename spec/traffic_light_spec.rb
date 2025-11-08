# frozen_string_literal: true

require 'spec_helper'

# Testes para a máquina de estados do semáforo
RSpec.describe TrafficLight::TrafficLight do
  let(:mock_configuration) { double('configuration') }
  let(:red_state) { TrafficLight::TrafficLightState.new('vermelho', 'PARA!', 15) }
  let(:green_state) { TrafficLight::TrafficLightState.new('verde', 'SEGUE AI', 10) }
  let(:yellow_state) { TrafficLight::TrafficLightState.new('amarelo', 'FICA LIGADO!', 5) }
  let(:states) { [red_state, green_state, yellow_state] }

  before do
    allow(mock_configuration).to receive(:states).and_return(states)
    allow(mock_configuration).to receive(:initial_state).and_return(red_state)
  end

  subject { described_class.new(mock_configuration) }

  describe '#initialize' do
    # Verifica se o estado inicial e a configuração são definidas corretamente
    it 'define o estado inicial como o primeiro estado' do
      expect(subject.current_state).to eq(red_state)
    end

    it 'define os estados a partir da configuração' do
      expect(subject.states).to eq(states)
    end

    it 'usa configuração padrão quando nenhuma é fornecida' do
      traffic_light = described_class.new
      expect(traffic_light.states).to eq(TrafficLight::TrafficLightConfiguration.states)
      expect(traffic_light.current_state).to eq(TrafficLight::TrafficLightConfiguration.initial_state)
    end
    
    it 'inicializa com índice de estado atual correto' do
      expect(subject.instance_variable_get(:@current_state_index)).to eq(0)
    end
  end

  describe '#next_state' do
    # Garante transições corretas e ciclo contínuo
    it 'faz transição de vermelho para verde' do
      expect { subject.next_state }.to change { subject.current_state }.from(red_state).to(green_state)
    end

    it 'faz transição de verde para amarelo' do
      subject.next_state
      expect { subject.next_state }.to change { subject.current_state }.from(green_state).to(yellow_state)
    end

    it 'faz transição de amarelo de volta para vermelho' do
      subject.next_state
      subject.next_state
      expect { subject.next_state }.to change { subject.current_state }.from(yellow_state).to(red_state)
    end

    it 'cicla continuamente pelos estados' do
      # Passa por um ciclo completo (vermelho -> verde -> amarelo -> vermelho)
      subject.next_state # verde
      subject.next_state # amarelo
      subject.next_state # vermelho
      expect(subject.current_state).to eq(red_state)
      
      # Próximo deve ser verde novamente
      subject.next_state
      expect(subject.current_state).to eq(green_state)
    end
    
    it 'funciona com configuração padrão' do
      traffic_light = described_class.new
      initial = traffic_light.current_state
      traffic_light.next_state
      expect(traffic_light.current_state).not_to eq(initial)
    end
  end

  describe '#current_message' do
    it 'retorna a mensagem do estado atual' do
      expect(subject.current_message).to eq('PARA!')
    end
    
    it 'funciona com configuração padrão' do
      traffic_light = described_class.new
      expect(traffic_light.current_message).to eq('PARA!')
    end
  end

  describe '#current_duration' do
    it 'retorna a duração do estado atual' do
      expect(subject.current_duration).to eq(15)
    end
    
    it 'funciona com configuração padrão' do
      traffic_light = described_class.new
      expect(traffic_light.current_duration).to eq(15)
    end
  end

  describe '#current_color' do
    it 'retorna a cor do estado atual' do
      expect(subject.current_color).to eq('vermelho')
    end
    
    it 'funciona com configuração padrão' do
      traffic_light = described_class.new
      expect(traffic_light.current_color).to eq('vermelho')
    end
  end

  describe '#in_state?' do
    it 'retorna true quando no estado especificado' do
      expect(subject.in_state?('vermelho')).to be true
    end
    
    it 'retorna false quando não está no estado especificado' do
      expect(subject.in_state?('verde')).to be false
    end
    
    it 'funciona com argumento symbol' do
      expect(subject.in_state?(:vermelho)).to be true
    end
    
    it 'atualiza após transição de estado' do
      subject.next_state
      expect(subject.in_state?('verde')).to be true
      expect(subject.in_state?('vermelho')).to be false
    end
  end
  
  describe 'delegação' do
    it 'delega color para current_state' do
      expect(subject.color).to eq('vermelho')
    end
    
    it 'delega message para current_state' do
      expect(subject.message).to eq('PARA!')
    end
    
    it 'delega duration para current_state' do
      expect(subject.duration).to eq(15)
    end
  end

  describe '#reset' do
    # Deve retornar ao estado inicial
    it 'reseta para o estado inicial' do
      subject.next_state
      subject.next_state
      expect { subject.reset }.to change { subject.current_state }.to(red_state)
    end
    
    it 'funciona com configuração padrão' do
      traffic_light = described_class.new
      traffic_light.next_state
      traffic_light.next_state
      expect { traffic_light.reset }.to change { traffic_light.current_color }.to('vermelho')
    end
  end
end