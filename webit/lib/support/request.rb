require 'rack'
require 'rack/respond_to'
require File.expand_path('../dispatcher', __FILE__)
class Request
  include Rack::RespondTo #mixes in #respond_to

  def self.call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    params = request.params
    unless request.post?
      content = Dispatcher.dispatch path
    else
      content = Dispatcher.dispatch path, params
    end
    get_response content
  end

  def self.get_response content
    Rack::RespondTo.media_types = ['text/html']
    redirect_url = nil
    body = respond_to do |format|
      if content.class == String
        format.html { content }
      else
        redirect_url = content[:url]
      end
    end
    unless redirect_url
      [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
    else
      [302, {'Location' => redirect_url}, []]
    end
  end
end