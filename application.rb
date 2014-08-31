require 'rack'
require 'rack/respond_to'
require_relative 'webit_view.rb'

module SampleApp
  class Application
    include Rack::RespondTo #mixes in #respond_to

    def self.call(env)

      request = Rack::Request.new(env)
      p request.post?
      params = request.params
      p params

      # Pass in the env, and RespondTo will retrieve the requested media types
      Rack::RespondTo.env = env
      # Alternatively, to use standalone you can also assign the media types
      # directly (this will take precedence over the env)
      # Rack::RespondTo.media_types = ['text/html']
      body = respond_to do |format|
       unless request.post?
          format.html { WebitView.render env }
        else
          format.html { WebitView.render env, params}
        end
        format.xml  { '<body>xml</body>' }
      end

      [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
    end
  end
end