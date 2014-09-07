require 'rack'
require 'rack/respond_to'

class Response
  include Rack::RespondTo

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