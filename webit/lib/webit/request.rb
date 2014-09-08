require 'rack'
require File.expand_path('../dispatcher', __FILE__)
require File.expand_path('../response', __FILE__)

class Request

  def self.call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    params = nil
    if request.post?
      params = request.params
    end
    content = Dispatcher.dispatch *[path, params].compact
    Response.response content
  end

end
