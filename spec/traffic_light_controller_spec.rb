# frozen_string_literal: true

require 'spec_helper'

# Testes para o controlador do semáforo (loop e temporização)
RSpec.describe TrafficLight::TrafficLightController do
  let(:mock_traffic_light) { double('traffic_light') }
  let(:mock_output) { StringIO.new }
  let(:red_state) { TrafficLight::TrafficLightState.new('vermelho', 'PARA!', 0.1) }
  let(:green_state) { TrafficLight::TrafficLightState.new('verde', 'SEGUE AI', 0.1) }

  subject { described_class.new(mock_traffic_light, mock_output) }

  before do
    allow(mock_traffic_light).to receive(:current_message).and_return('PARA!')
    allow(mock_traffic_light).to receive(:current_duration).and_return(0.1)
    allow(mock_traffic_light).to receive(:next_state)
  end

  describe '#initialize' do
    # Deve iniciar com referências corretas e não estar rodando
    it 'sets the traffic light and output' do
      expect(subject.instance_variable_get(:@traffic_light)).to eq(mock_traffic_light)
      expect(subject.instance_variable_get(:@output)).to eq(mock_output)
    end

    it 'initializes as not running' do
      expect(subject.running?).to be false
    end
    
    it 'uses default traffic light and output when none provided' do
      controller = described_class.new
      expect(controller.instance_variable_get(:@traffic_light)).to be_a(TrafficLight::TrafficLight)
      expect(controller.instance_variable_get(:@output)).to eq($stdout)
      expect(controller.running?).to be false
    end
  end

  describe '#start' do
    # Inicia o ciclo e chama run_cycle
    it 'sets running to true' do
      allow(subject).to receive(:run_cycle)
      expect { subject.start }.to change { subject.running? }.from(false).to(true)
    end

    it 'calls run_cycle' do
      expect(subject).to receive(:run_cycle).once.and_return(nil)
      subject.start
    end
  end

  describe '#stop' do
    # Deve parar o ciclo
    it 'sets running to false' do
      allow(subject).to receive(:run_cycle)
      subject.start
      expect { subject.stop }.to change { subject.running? }.from(true).to(false)
    end
  end

  describe '#running?' do
    it 'returns true when started' do
      allow(subject).to receive(:run_cycle)
      subject.start
      expect(subject.running?).to be true
    end

    it 'returns false when stopped' do
      subject.stop
      expect(subject.running?).to be false
    end
  end

  describe 'private methods' do
    describe '#display_current_state' do
      # Deve escrever no output injetado
      it 'outputs the current message' do
        subject.send(:display_current_state)
        expect(mock_output.string).to eq("PARA!\n")
      end
    end

    describe '#run_cycle' do
      it 'displays current state and transitions to next state' do
        allow(subject).to receive(:sleep)
        # Com duration 0.1: running? é chamado: 1) no while, 2) no transition_to_next_state, 3) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, false)

        expect(mock_traffic_light).to receive(:current_message).at_least(:once)
        expect(mock_traffic_light).to receive(:current_duration).at_least(:once)
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end

      it 'stops cycling when running is false' do
        allow(subject).to receive(:sleep)
        allow(subject).to receive(:running?).and_return(false)

        expect(mock_traffic_light).not_to receive(:next_state)

        subject.send(:run_cycle)
      end
      
      it 'handles durations less than 1 second' do
        allow(mock_traffic_light).to receive(:current_duration).and_return(0.5)
        allow(subject).to receive(:sleep)
        # running? é chamado: 1) no while, 2) no transition_to_next_state, 3) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, false)

        expect(mock_traffic_light).to receive(:current_message).at_least(:once)
        expect(subject).to receive(:sleep).with(0.5)
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end
      
      it 'handles durations of 1 second or more with multiple displays' do
        allow(mock_traffic_light).to receive(:current_duration).and_return(2)
        allow(subject).to receive(:sleep)
        # running? é chamado: 1) no while, 2) no times.do (2x), 3) no transition_to_next_state, 4) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, true, true, false)

        expect(mock_traffic_light).to receive(:current_message).at_least(2).times
        expect(subject).to receive(:sleep).with(1).at_least(2).times
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end
    end
  end
end