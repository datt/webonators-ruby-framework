#!/usr/bin/env ruby
require ::File.expand_path('../application', __FILE__)
Rack::Server.start app: SampleApp::Application, Port: 3000
