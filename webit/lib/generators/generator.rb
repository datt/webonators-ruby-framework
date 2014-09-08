require ::File.expand_path("../generator/model.rb", __FILE__)
require ::File.expand_path("../generator/controller.rb", __FILE__)
module Generator
  class Base
    def generating_model_controller argument_array
      get_generator_parameter argument_array
    end
    private
      def get_generator_parameter argument_array
        model_controller_keyword = argument_array
        if model_controller_keyword.downcase.eql?"model"
          Model.new.call_for_model_operations argv
        elsif model_controller_keyword.downcase.eql?"controller"
          Controller.new.call_for_controller_operations argv
        end
      end
  end
end