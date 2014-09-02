require_relative 'webit_view.rb'
require_relative 'routes.rb'
require_relative 'webo_controller'
require ::File.expand_path('../posts_controller',  __FILE__)
require ::File.expand_path('../users_controller',  __FILE__)

module SampleApp
  class Application < WeboController

  end
end