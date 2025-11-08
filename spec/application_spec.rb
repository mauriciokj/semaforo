# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TrafficLight::Application do
  describe '.run' do
    let(:mock_controller) { double('controller') }

    before do
      allow(TrafficLight::TrafficLightController).to receive(:new).and_return(mock_controller)
      allow(mock_controller).to receive(:start)
      allow(mock_controller).to receive(:stop)
    end

    it 'cria um novo controller' do
      # Mock do trap para prevenir configuração de signal handler
      allow(described_class).to receive(:trap)
      
      expect(TrafficLight::TrafficLightController).to receive(:new).and_return(mock_controller)
      described_class.run
    end

    it 'inicia o controller' do
      # Mock do trap para prevenir configuração de signal handler
      allow(described_class).to receive(:trap)
      
      expect(mock_controller).to receive(:start)
      described_class.run
    end

    it 'configura trap de sinal para encerramento gracioso' do
      # Mock do exit para prevenir término do teste
      allow(described_class).to receive(:exit)
      
      expect(described_class).to receive(:trap).with('INT').and_yield
      expect(mock_controller).to receive(:stop)
      expect(described_class).to receive(:exit).with(0)
      
      described_class.run
    end

    it 'imprime mensagem de inicialização' do
      # Mock do trap para prevenir configuração de signal handler
      allow(described_class).to receive(:trap)
      
      expect { described_class.run }.to output(/Iniciando semáforo.../).to_stdout
    end
  end
end