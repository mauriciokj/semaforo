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
    it 'sets the initial state to the first state' do
      expect(subject.current_state).to eq(red_state)
    end

    it 'sets the states from configuration' do
      expect(subject.states).to eq(states)
    end

    it 'uses default configuration when none provided' do
      traffic_light = described_class.new
      expect(traffic_light.states).to eq(TrafficLight::TrafficLightConfiguration.states)
      expect(traffic_light.current_state).to eq(TrafficLight::TrafficLightConfiguration.initial_state)
    end
    
    it 'initializes with correct current state index' do
      expect(subject.instance_variable_get(:@current_state_index)).to eq(0)
    end
  end

  describe '#next_state' do
    # Garante transições corretas e ciclo contínuo
    it 'transitions from red to green' do
      expect { subject.next_state }.to change { subject.current_state }.from(red_state).to(green_state)
    end

    it 'transitions from green to yellow' do
      subject.next_state
      expect { subject.next_state }.to change { subject.current_state }.from(green_state).to(yellow_state)
    end

    it 'transitions from yellow back to red' do
      subject.next_state
      subject.next_state
      expect { subject.next_state }.to change { subject.current_state }.from(yellow_state).to(red_state)
    end

    it 'cycles continuously through states' do
      # Go through one complete cycle (red -> green -> yellow -> red)
      subject.next_state # green
      subject.next_state # yellow
      subject.next_state # red
      expect(subject.current_state).to eq(red_state)
      
      # Next should be green again
      subject.next_state
      expect(subject.current_state).to eq(green_state)
    end
    
    it 'works with default configuration' do
      traffic_light = described_class.new
      initial = traffic_light.current_state
      traffic_light.next_state
      expect(traffic_light.current_state).not_to eq(initial)
    end
  end

  describe '#current_message' do
    it 'returns the message of the current state' do
      expect(subject.current_message).to eq('PARA!')
    end
    
    it 'works with default configuration' do
      traffic_light = described_class.new
      expect(traffic_light.current_message).to eq('PARA!')
    end
  end

  describe '#current_duration' do
    it 'returns the duration of the current state' do
      expect(subject.current_duration).to eq(15)
    end
    
    it 'works with default configuration' do
      traffic_light = described_class.new
      expect(traffic_light.current_duration).to eq(15)
    end
  end

  describe '#current_color' do
    it 'returns the color of the current state' do
      expect(subject.current_color).to eq('vermelho')
    end
    
    it 'works with default configuration' do
      traffic_light = described_class.new
      expect(traffic_light.current_color).to eq('vermelho')
    end
  end

  describe '#in_state?' do
    it 'returns true when in the specified state' do
      expect(subject.in_state?('vermelho')).to be true
    end
    
    it 'returns false when not in the specified state' do
      expect(subject.in_state?('verde')).to be false
    end
    
    it 'works with symbol argument' do
      expect(subject.in_state?(:vermelho)).to be true
    end
    
    it 'updates after state transition' do
      subject.next_state
      expect(subject.in_state?('verde')).to be true
      expect(subject.in_state?('vermelho')).to be false
    end
  end
  
  describe 'delegation' do
    it 'delegates color to current_state' do
      expect(subject.color).to eq('vermelho')
    end
    
    it 'delegates message to current_state' do
      expect(subject.message).to eq('PARA!')
    end
    
    it 'delegates duration to current_state' do
      expect(subject.duration).to eq(15)
    end
  end

  describe '#reset' do
    # Deve retornar ao estado inicial
    it 'resets to the initial state' do
      subject.next_state
      subject.next_state
      expect { subject.reset }.to change { subject.current_state }.to(red_state)
    end
    
    it 'works with default configuration' do
      traffic_light = described_class.new
      traffic_light.next_state
      traffic_light.next_state
      expect { traffic_light.reset }.to change { traffic_light.current_color }.to('vermelho')
    end
  end
end