require_relative "../support/execute_generator.rb"
class Generator
  def self.generating_model_controller argv
     ExecuteGenerator.get_generator_parameter argv
  end
end