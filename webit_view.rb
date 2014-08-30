#!/usr/bin/env ruby
#require ::File.expand_path('../tmp/controller/posts_controller',  __FILE__)
#require ::File.expand_path('../tmp/controller/users_controller',  __FILE__)
require 'erubis'
require_relative 'routes.rb'

module WebitView

  def self.parse_routes env
    routes = WeboRoutes.routes
    routes.each do |url, variables|
      if url.eql? env['REQUEST_PATH']
        return { url: url, 
                 method: variables[0], 
                 controller: variables[1], 
                 action: variables[2]
               }
      end
    end
  end

  def self.render env
    route_variables = parse_routes env
    controller = Object.const_get "#{route_variables[:controller]}"
    unless route_variables.nil?
      object = controller.new
      object.send "#{route_variables[:action]}"
      template = Erubis::Eruby.new File.read("tmp/controller/#{route_variables[:action]}.html.erb")
      template.result(object.instance_eval {binding})
    else
      template = "<h1>Error 404. Page not found<h1>
                  <h2>Some error occurred due to routes.rb.
                  Please check routes file.<h2>"
    end
  end
end