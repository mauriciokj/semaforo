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
    it 'define o traffic light e output' do
      expect(subject.instance_variable_get(:@traffic_light)).to eq(mock_traffic_light)
      expect(subject.instance_variable_get(:@output)).to eq(mock_output)
    end

    it 'inicializa como não rodando' do
      expect(subject.running?).to be false
    end
    
    it 'usa traffic light e output padrão quando nenhum é fornecido' do
      controller = described_class.new
      expect(controller.instance_variable_get(:@traffic_light)).to be_a(TrafficLight::TrafficLight)
      expect(controller.instance_variable_get(:@output)).to eq($stdout)
      expect(controller.running?).to be false
    end
  end

  describe '#start' do
    # Inicia o ciclo e chama run_cycle
    it 'define running como true' do
      allow(subject).to receive(:run_cycle)
      expect { subject.start }.to change { subject.running? }.from(false).to(true)
    end

    it 'chama run_cycle' do
      expect(subject).to receive(:run_cycle).once.and_return(nil)
      subject.start
    end
  end

  describe '#stop' do
    # Deve parar o ciclo
    it 'define running como false' do
      allow(subject).to receive(:run_cycle)
      subject.start
      expect { subject.stop }.to change { subject.running? }.from(true).to(false)
    end
  end

  describe '#running?' do
    it 'retorna true quando iniciado' do
      allow(subject).to receive(:run_cycle)
      subject.start
      expect(subject.running?).to be true
    end

    it 'retorna false quando parado' do
      subject.stop
      expect(subject.running?).to be false
    end
  end

  describe 'private methods' do
    describe '#display_current_state' do
      # Deve escrever no output injetado
      it 'exibe a mensagem atual' do
        subject.send(:display_current_state)
        expect(mock_output.string).to eq("PARA!\n")
      end
    end

    describe '#run_cycle' do
      it 'exibe estado atual e faz transição para próximo estado' do
        allow(subject).to receive(:sleep)
        # Com duration 0.1: running? é chamado: 1) no while, 2) no times.do (1x), 3) no transition_to_next_state, 4) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, true, false)

        expect(mock_traffic_light).to receive(:current_message).at_least(:once)
        expect(mock_traffic_light).to receive(:current_duration).at_least(:once)
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end

      it 'para o ciclo quando running é false' do
        allow(subject).to receive(:sleep)
        allow(subject).to receive(:running?).and_return(false)

        expect(mock_traffic_light).not_to receive(:next_state)

        subject.send(:run_cycle)
      end
      
      it 'trata durações menores que 1 segundo (garante 1 iteração)' do
        allow(mock_traffic_light).to receive(:current_duration).and_return(0.5)
        allow(subject).to receive(:sleep)
        # running? é chamado: 1) no while, 2) no times.do (1x), 3) no transition_to_next_state, 4) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, true, false)

        expect(mock_traffic_light).to receive(:current_message).once
        expect(subject).to receive(:sleep).with(0.5).once
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end
      
      it 'trata durações de 1 segundo ou mais com múltiplas exibições' do
        allow(mock_traffic_light).to receive(:current_duration).and_return(2)
        allow(subject).to receive(:sleep)
        # running? é chamado: 1) no while, 2) no times.do (2x), 3) no transition_to_next_state, 4) no while novamente
        allow(subject).to receive(:running?).and_return(true, true, true, true, false)

        expect(mock_traffic_light).to receive(:current_message).exactly(2).times
        expect(subject).to receive(:sleep).with(1).exactly(2).times
        expect(mock_traffic_light).to receive(:next_state).once

        subject.send(:run_cycle)
      end
    end
  end
end