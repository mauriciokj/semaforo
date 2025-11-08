# frozen_string_literal: true

require 'spec_helper'

# Testes para configuração dos estados do semáforo
RSpec.describe TrafficLight::TrafficLightConfiguration do
  describe '.states' do
    # Deve retornar os três estados com cor, mensagem e duração corretamente
    it 'retorna os estados configurados do semáforo' do
      states = described_class.states
      
      expect(states.length).to eq(3)
      expect(states[0].color).to eq('vermelho')
      expect(states[0].message).to eq('PARA!')
      expect(states[0].duration).to eq(15)
      
      expect(states[1].color).to eq('verde')
      expect(states[1].message).to eq('SEGUE AI')
      expect(states[1].duration).to eq(10)
      
      expect(states[2].color).to eq('amarelo')
      expect(states[2].message).to eq('FICA LIGADO!')
      expect(states[2].duration).to eq(5)
    end

    # A coleção deve ser imutável para evitar alterações em runtime
    it 'retorna array congelado para prevenir modificação' do
      expect(described_class.states).to be_frozen
    end
  end

  describe '.initial_state' do
    # Estado inicial deve ser vermelho
    it 'retorna o primeiro estado (vermelho)' do
      initial_state = described_class.initial_state
      expect(initial_state.color).to eq('vermelho')
      expect(initial_state.message).to eq('PARA!')
      expect(initial_state.duration).to eq(15)
    end
  end
end