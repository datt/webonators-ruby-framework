#!/usr/bin/env ruby
require 'rack'
require 'rack/respond_to'
require_relative 'webo_view.rb'

class App
  include Rack::RespondTo #mixes in #respond_to

  def self.call(env)
    # Pass in the env, and RespondTo will retrieve the requested media types
    Rack::RespondTo.env = env

    # Alternatively, to use standalone you can also assign the media types
    # directly (this will take precedence over the env)
    # Rack::RespondTo.media_types = ['text/html']
      body = respond_to do |format|
        format.html { WeboView.render env }
        format.xml  { '<body>xml</body>' }
      end
      req = Rack::Request.new(env)
      p req.post?
      p req.params

      [200, {'Content-Type' => Rack::RespondTo.selected_media_type}, [body]]
    end
end

Rack::Server.start app: App, Port: 3000
