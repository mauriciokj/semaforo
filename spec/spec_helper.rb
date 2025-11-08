# frozen_string_literal: true

require 'simplecov'
# Configura o SimpleCov para medir cobertura de testes
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  # Meta de cobertura: 100% para arquivos do projeto
  minimum_coverage 100
end

require_relative '../lib/traffic_light_state'
require_relative '../lib/traffic_light_configuration'
require_relative '../lib/traffic_light'
require_relative '../lib/traffic_light_controller'
require_relative '../semaforo'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.warnings = true

  # Usa um formatter mais detalhado quando rodar um único arquivo
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # Executa os testes em ordem aleatória para detectar dependências entre eles
  config.order = :random
  Kernel.srand config.seed
end
