require 'rack'
require 'rack/respond_to'
require File.expand_path('../dispatcher', __FILE__)
class Request
  include Rack::RespondTo #mixes in #respond_to

  def self.call(env)
    request = Rack::Request.new(env)
    path = request.path_info
    params = request.params
    # Pass in the env, and RespondTo will retrieve the requested media types
    #response = Rack::Response.new
    # Alternatively, to use standalone you can also assign the media types
     # directly (this will take precedence over the env)
    Rack::RespondTo.media_types = ['text/html']
    body = respond_to do |format|
      unless request.post?
        content = Dispatcher.dispatch path
     else
        content = Dispatcher.dispatch path, params
      end

      #if content.class == String
        format.html { content }
      #else
      #  response = Rack::Response.new
      #  response.redirect("http://www.google.com")
      #  response.finish
      #end
      #format.xml  { '<body>xml</body>' }
    end
    [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
  end
end