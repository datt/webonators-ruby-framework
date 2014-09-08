
require ::File.expand_path("../webit/dispatcher", __FILE__)
require ::File.expand_path("../webit/webit_model", __FILE__)
require ::File.expand_path("../webit/webit_controller", __FILE__)
require ::File.expand_path("../webit/webit_routes", __FILE__)
require ::File.expand_path("../webit/request", __FILE__)

module Webit
  autoload :WebitRoutes, 'webit/webit_routes'
  autoload :Dispatcher, 'webit/dispatcher'
  autoload :Request, 'webit/request'
  autoload :WebitModel, 'webit/webit_model'
  autoload :WebitController, 'webit/webit_controller'
end