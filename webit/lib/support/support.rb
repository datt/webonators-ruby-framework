require ::File.expand_path("../dispatcher", __FILE__)
require ::File.expand_path("../webit_model", __FILE__)
require ::File.expand_path("../webit_controller", __FILE__)
require ::File.expand_path("../webit_routes", __FILE__)
require ::File.expand_path("../request", __FILE__)
#require ::File.expand_path("../error.yml", __FILE__)

autoload :WebitRoutes, 'webit_routes'
autoload :Dispatcher, 'dispatcher'
autoload :Request, 'request'
autoload :WebitModel, 'webit_model'
autoload :WebitController, 'webit_controller'