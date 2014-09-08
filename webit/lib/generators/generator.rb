require ::File.expand_path("../generator/model.rb", __FILE__)
require ::File.expand_path("../generator/controller.rb", __FILE__)
module Generator
  class Base
    def generating_model_controller argv
      get_generator_parameter argv
    end
    private
      def get_generator_parameter argv
        if argv[1].downcase.eql?"model"
          puts "inside kick start"
          Model.new.call_for_model_operations argv
        elsif argv[1].downcase.eql?"controller"
          Controller.new.call_for_controller_operations argv
        end
      end
  end
end