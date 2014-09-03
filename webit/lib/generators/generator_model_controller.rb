require ::File.expand_path("../../support/execute_generator.rb", __FILE__)
class Generator
  def self.generating_model_controller argv
     ExecuteGenerator.get_generator_parameter argv
  end
end