class Dispatcher

  # define -> dispatch() method accepts path_info from request, parse routes,
  # and call appropriate Controller's action. Also provides static css and js files if necessary. 
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

  # define -> parse_routes(). Accepts path_info
  # returns route hash with url as key and Controller's name, action name and method as an array.
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

  # define -> parse_id(). Accepts path_info
  # returns id if present, else nil.
  def self.parse_id path_info
    id = nil
    if path_info.match /[\d]+/
      id = path_info.match /[\d]+/
      id = id[0].to_i
    end
    id
   end

  # define -> get_static_pages(). Accepts path_info
  # returns static CSS or Javascript based on the request.
  def self.get_static_pages path_info
    stylesheet = File.read("#{ROOT}/app/assets/style.css")
    javascript = File.read("#{ROOT}/app/assets/script.js")
    if path_info.split(".").last.eql? "js"
      {js: javascript}
    elsif path_info.split(".").last.eql? "css"
      {css: stylesheet}
    end
  end
end