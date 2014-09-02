require 'rack'
require 'rack/respond_to'
require File.expand_path('../dispatcher', __FILE__)
class Request
  include Rack::RespondTo #mixes in #respond_to

  def self.call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    params = request.params
    Rack::RespondTo.media_types = ['text/html']
    body = respond_to do |format|
      unless request.post?
        content = Dispatcher.dispatch path
      else
        content = Dispatcher.dispatch path, params
      end
      format.html { content }
    end
    [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
  end
end