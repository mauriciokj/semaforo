# frozen_string_literal: true

require 'spec_helper'

# Testes para o modelo de estado do semáforo
RSpec.describe TrafficLight::TrafficLightState do
  let(:state) { described_class.new('vermelho', 'PARA!', 15) }

  describe '#initialize' do
    it 'define cor, mensagem e duração' do
      expect(state.color).to eq('vermelho')
      expect(state.message).to eq('PARA!')
      expect(state.duration).to eq(15)
    end
  end

  describe 'imutabilidade' do
    it 'congela o objeto' do
      expect(state).to be_frozen
    end
    
    it 'congela a string de cor' do
      expect(state.color).to be_frozen
    end
    
    it 'congela a string de mensagem' do
      expect(state.message).to be_frozen
    end
  end
  
  describe 'validações' do
    it 'lança erro para cor nil' do
      expect { described_class.new(nil, 'PARA!', 15) }.to raise_error(ArgumentError, /color cannot be nil/)
    end
    
    it 'lança erro para cor vazia' do
      expect { described_class.new('', 'PARA!', 15) }.to raise_error(ArgumentError, /color cannot be nil/)
    end
    
    it 'lança erro para mensagem nil' do
      expect { described_class.new('vermelho', nil, 15) }.to raise_error(ArgumentError, /message cannot be nil/)
    end
    
    it 'lança erro para mensagem vazia' do
      expect { described_class.new('vermelho', '', 15) }.to raise_error(ArgumentError, /message cannot be nil/)
    end
    
    it 'lança erro para duração zero' do
      expect { described_class.new('vermelho', 'PARA!', 0) }.to raise_error(ArgumentError, /duration must be positive/)
    end
    
    it 'lança erro para duração negativa' do
      expect { described_class.new('vermelho', 'PARA!', -5) }.to raise_error(ArgumentError, /duration must be positive/)
    end
  end
end