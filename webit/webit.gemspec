Gem::Specification.new do |spec|
  spec.name  = "webit"
  spec.version = "0.0.1"
  spec.date  = "2014-08-30"
  spec.summary = "MVC Framework"
  spec.description = "Webit is MVC framework developed in Language Ruby. This will make an easy way for user to create web Application."
  spec.authors  = ["Taha Husain","Palash Kulkarni","Minakhi Najardhane","Kartik Nagre"]
  spec.email = ["taha.husain@weboniselab.com","palash.kulkarni@weboniselab.com","minakshi.najardhane@weboniselab.com","kartik.nagre@weboniselab.com"]
  spec.files = ["lib/generators/generate_app_directory.rb", "lib/generators/generator_model_controller.rb", "lib/support/execute_generator.rb", "lib/support/generate_configuration.rb", "lib/support/initializers.rb","lib/support/webit_controller.rb","lib/support/webit_model.rb", "lib/support/connection.rb", "lib/support/error.yml", "lib/support/mysql_adapter.rb", "lib/support/webit_view.rb"]
  spec.executables = ["webit"]
  spec.license = "MIT"
end