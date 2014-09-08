class WebitRoutes
  @@routes = {}

  def self.routes=routes
    @@routes = routes
  end

  def self.routes
    @@routes
  end

  # define -> get(). Accepts a url and block and return a key value pair
  # key will be url and value will be an array of Controller's name, action's name and HTTP method.
  def self.get(url, &block)
    @@routes[url] = ["get"] + self.class_eval(&block)
  end

  # define -> post(). Same as get method except that it adds post HTTP method in array.
  def self.post(url, &block)
    @@routes[url] = ["post"] + self.class_eval(&block)
  end

  # define -> goto(). This is used as a block and evaluated in get and post methods.
  # Returns Controller and action's name.
  def self.goto(controller, action)
    [controller, action]
  end
end