#!/usr/bin/env ruby
require ::File.expand_path("../config/application.rb", __FILE__)
use Rack::Static, :urls => ["/assests"], :root => '/assets/'
Rack::Handler::WEBrick.run( WeBlog::Application, :Port => 3000)