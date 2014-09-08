class Dispatcher

   def self.dispatch path_info, params=nil
    route_variables = parse_routes path_info.gsub /[\d]+/, ":id"
    unless route_variables[:url].nil?
      controller = Object.const_get "#{route_variables[:controller]}"
      object = controller.new
      id = parse_id path_info
      object.send "#{route_variables[:action]}", *[id,params].compact
    else
      get_static_pages path_info
    end
  end

  private

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
    id = nil
    if path_info.match /[\d]+/
      id = path_info.match /[\d]+/
      id = id[0].to_i
    end
    id
   end

  def self.get_static_pages path_info
    stylesheet = File.read("#{ROOT}/app/assets/style.css")
    javascript = File.read("#{ROOT}/app/assets/script.js")
    if path_info.split(".").last.eql? "js"
      {js: javascript}
    else
      {css: stylesheet}
    end
  end
end