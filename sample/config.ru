#!/usr/bin/env ruby
require ::File.expand_path("../config/application.rb", __FILE__)
Rack::Handler::WEBrick.run( Sample::Application, :Port => 3000)