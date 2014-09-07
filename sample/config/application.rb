require 'webit'
require ::File.expand_path('../routes.rb', __FILE__)
Dir["app/controllers/*.rb"].each {|file| require_relative "../"+file}
Dir["app/models/*.rb"].each {|file| require_relative "../"+file}
module Sample
  class Application < Request
  end
end