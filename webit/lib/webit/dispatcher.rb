require 'erubis'

class Dispatcher

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

  def self.parse_id path_info
    if path_info.match /[\d]+/
      id = path_info.match /[\d]+/
      id = id[0].to_i
    else
       id = nil
     end
     id
   end

   def self.dispatch path_info, params=nil
    route_variables = parse_routes path_info.gsub /[\d]+/, ":id"
    unless route_variables.nil?
      controller = Object.const_get "#{route_variables[:controller]}"
      object = controller.new
      id = parse_id path_info
      if params && id
        object.send "#{route_variables[:action]}", id, params
      elsif params
        object.send "#{route_variables[:action]}", params
      elsif id
        object.send "#{route_variables[:action]}", id
      else
        object.send "#{route_variables[:action]}"
      end
    end
  end
end