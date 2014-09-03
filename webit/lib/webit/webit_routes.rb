class WebitRoutes
  @@routes = {}

  def self.routes=routes
    @@routes = routes
  end

  def self.routes
    @@routes
  end

  def self.get(url, &block)
    @@routes[url] = ["get"] + self.class_eval(&block)
  end

  def self.post(url, &block)
    @@routes[url] = ["post"] + self.class_eval(&block)
  end

  def self.goto(controller, action)
    [controller, action]
  end
end