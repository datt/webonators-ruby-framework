#!/usr/bin/env ruby
require ::File.expand_path("../config/application.rb", __FILE__)
use Rack::Static,
  :urls => ["/images", "/js", "/css"],
  :root => "app/view/asset"
Rack::Handler::WEBrick.run( WeBlog::Application, :Port => 3000)