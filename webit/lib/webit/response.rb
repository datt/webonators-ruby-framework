require 'rack'
require 'rack/respond_to'

class Response
  include Rack::RespondTo

  def self.response content
    Rack::RespondTo.media_types = %w( text/html text/css application/javascript )
    redirect_url = nil
    body = respond_to do |format|
      if content.class.eql? String
        format.html { content }
      elsif content.key? :url
        redirect_url = content[:url]
      elsif content.key? :js
        format.js { content[:js] }
      else
        format.css { content[:css] }
      end
    end
    unless redirect_url
      [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
    else
      [302, {'Location' => redirect_url}, []]
    end
  end

end