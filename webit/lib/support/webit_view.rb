require 'erubis'

class WebitView

  def self.parse_routes path_info
    routes = WebitRoutes.routes
    routes.each do |url, variables|
      if url.eql? path_info
        return { url: url,
                 method: variables[0],
                 controller: variables[1],
                 action: variables[2]
               }
      end
    end
  end

  def self.render path_info, params=nil
    puts "\n\n\nThis is webit view's render\n\n\n"
    route_variables = parse_routes path_info
    unless route_variables.nil?
      controller = Object.const_get "#{route_variables[:controller]}"
      object = controller.new
      if params
        object.send "#{route_variables[:action]}", params
      else
        object.send "#{route_variables[:action]}"
      end
      template = Erubis::Eruby.new File.read("#{route_variables[:action]}.html.erb")
      template.result(object.instance_eval {binding})
    else
      template = "<h1>Error 404. Page not found</h1>
                  <h2>Some error occurred due to routes.rb.
                  Please check routes file.</h2>"
    end
  end

end