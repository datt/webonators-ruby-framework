require 'rack'
require 'rack/respond_to'

class Response
  include Rack::RespondTo

  # define -> response(). This method returns the response back to browser via call method in Request class.
  # Accepts either content in form of HTML or CSS or Javascript or a url to which page is to be redirected.
  def self.response content
    Rack::RespondTo.media_types = %w( text/html text/css application/javascript )
    redirect_url = nil
    body = respond_to do |format|
      if content.keys.first.eql? :url
        redirect_url = content[:url]
      else
        format.send(content.keys.first) { content.values.first }
      end
    end
    status = content.values.last
    unless redirect_url
      [status, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
    else
      [status, {'Location' => redirect_url}, []]
    end
  end

end