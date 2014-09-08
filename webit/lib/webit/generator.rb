require ::File.expand_path("../generator/model.rb", __FILE__)
require ::File.expand_path("../generator/controller.rb", __FILE__)
module Generator
  class Base
    def generating_model_controller argument_array
      get_generator_parameter argument_array
    end
    private
      def get_generator_parameter argument_array
        model_controller_keyword = argument_array[1]
        if model_controller_keyword.downcase.eql?"model"
          Model.new.generate argument_array
        elsif model_controller_keyword.downcase.eql?"controller"
          Controller.new.generate argument_array
        end
      end
  end
end