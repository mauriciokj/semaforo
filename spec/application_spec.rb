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

    it 'creates a new controller' do
      # Mock trap to prevent signal handler setup
      allow(described_class).to receive(:trap)
      
      expect(TrafficLight::TrafficLightController).to receive(:new).and_return(mock_controller)
      described_class.run
    end

    it 'starts the controller' do
      # Mock trap to prevent signal handler setup
      allow(described_class).to receive(:trap)
      
      expect(mock_controller).to receive(:start)
      described_class.run
    end

    it 'sets up signal trap for graceful shutdown' do
      # Mock exit to prevent test termination
      allow(described_class).to receive(:exit)
      
      expect(described_class).to receive(:trap).with('INT').and_yield
      expect(mock_controller).to receive(:stop)
      expect(described_class).to receive(:exit).with(0)
      
      described_class.run
    end

    it 'prints startup message' do
      # Mock trap to prevent signal handler setup
      allow(described_class).to receive(:trap)
      
      expect { described_class.run }.to output(/Iniciando semáforo.../).to_stdout
    end
  end
end