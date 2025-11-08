# frozen_string_literal: true

require 'spec_helper'

# Testes para o modelo de estado do semáforo
RSpec.describe TrafficLight::TrafficLightState do
  let(:state) { described_class.new('vermelho', 'PARA!', 15) }

  describe '#initialize' do
    it 'sets the color, message, and duration' do
      expect(state.color).to eq('vermelho')
      expect(state.message).to eq('PARA!')
      expect(state.duration).to eq(15)
    end
  end

  describe '#to_s' do
    # Deve retornar string formatada com a cor em maiúsculas
    it 'returns a formatted string representation' do
      expect(state.to_s).to eq('VERMELHO: PARA!')
    end
  end

  describe '#==' do
    # Compara igualdade por atributos
    let(:same_state) { described_class.new('vermelho', 'PARA!', 15) }
    let(:different_state) { described_class.new('verde', 'SEGUE AI', 10) }

    it 'returns true for identical states' do
      expect(state).to eq(same_state)
    end

    it 'returns false for different states' do
      expect(state).not_to eq(different_state)
    end

    it 'returns false for non-TrafficLightState objects' do
      expect(state).not_to eq('not a state')
    end
  end
  
  describe '#eql?' do
    it 'behaves the same as ==' do
      same_state = described_class.new('vermelho', 'PARA!', 15)
      expect(state.eql?(same_state)).to be true
    end
  end
  
  describe '#hash' do
    it 'returns the same hash for identical states' do
      same_state = described_class.new('vermelho', 'PARA!', 15)
      expect(state.hash).to eq(same_state.hash)
    end
    
    it 'returns different hash for different states' do
      different_state = described_class.new('verde', 'SEGUE AI', 10)
      expect(state.hash).not_to eq(different_state.hash)
    end
  end
  
  describe 'immutability' do
    it 'freezes the object' do
      expect(state).to be_frozen
    end
    
    it 'freezes the color string' do
      expect(state.color).to be_frozen
    end
    
    it 'freezes the message string' do
      expect(state.message).to be_frozen
    end
  end
  
  describe 'validations' do
    it 'raises error for nil color' do
      expect { described_class.new(nil, 'PARA!', 15) }.to raise_error(ArgumentError, /color cannot be nil/)
    end
    
    it 'raises error for empty color' do
      expect { described_class.new('', 'PARA!', 15) }.to raise_error(ArgumentError, /color cannot be nil/)
    end
    
    it 'raises error for nil message' do
      expect { described_class.new('vermelho', nil, 15) }.to raise_error(ArgumentError, /message cannot be nil/)
    end
    
    it 'raises error for empty message' do
      expect { described_class.new('vermelho', '', 15) }.to raise_error(ArgumentError, /message cannot be nil/)
    end
    
    it 'raises error for zero duration' do
      expect { described_class.new('vermelho', 'PARA!', 0) }.to raise_error(ArgumentError, /duration must be positive/)
    end
    
    it 'raises error for negative duration' do
      expect { described_class.new('vermelho', 'PARA!', -5) }.to raise_error(ArgumentError, /duration must be positive/)
    end
  end
end