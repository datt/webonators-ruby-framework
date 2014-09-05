#!/usr/bin/env ruby
require ::File.expand_path("../config/application.rb", __FILE__)
Rack::Handler::WEBrick.run( WeBlog::Application, :Port => 3000)