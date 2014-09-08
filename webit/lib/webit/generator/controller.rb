require ::File.expand_path("../../webit_controller.rb", __FILE__)
require 'fileutils'

class Controller
MIN_ARGUMENT_LENGTH = 3
  # function to accept controller name either with or without actions
  def generate argv
    actions = []
    controller_name = argv[2]
    if controller_name.nil?
      puts error_msg("error.controller_error.perror")
    elsif controller_name.downcase.eql? "controller"
      puts error_msg("error.controller_error.same")
    else
      if controller_name[controller_name.length-1]!='s'
        controller_name="#{controller_name}s"
      end
      create_controller_class controller_name
      if argv.length > MIN_ARGUMENT_LENGTH
        argv.each_with_index do |action, index|
          if index > 2
            actions << action.downcase
            write_def_controller controller_name,action
            create_view_file action
            write_action_routes controller_name,action
            write_to_view controller_name,action
          end
        end
      end
    end
    endfile_condition controller_name
  end

  private

    # method to include user errors
    def error_msg(keys)
      path_error_yml = File.expand_path("../../../config/error.yml", __FILE__)
      config_error = YAML.load_file("#{path_error_yml}")
      keys.split(".").inject(config_error) { |config_error, key| config_error[key] }
    end

    # method that creates controller class in user application
    def create_controller_class controller_name
      controller_name = controller_name.downcase
      controller_class_name = controller_name.split('_').each {|word| word.capitalize!}
      controller_class_name = controller_class_name.join.concat("Controller")
      write_controller = File.new("app/controllers/#{controller_name}_controller.rb","w")
      write_controller.write "class #{controller_class_name} < WebitController\n"
      write_controller.close
    end

    # method to add end keyword in controller class and routes file
    def endfile_condition controller_name
      write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a")
      write_controller.write "\nend"
      write_controller.close
      write_routes = File.open("config/routes.rb","a")
      write_routes.write("\nend")
      write_routes.close
    end

    # method to write definitons of all actions in controller class
    def write_def_controller controller_name,action
      write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a+")
      write_controller.write("\n\s\sdef #{action}\n\s\send\n")
      write_controller.close
    end

    # method that writes routes for all actions in routes file
    def write_action_routes controller_class_name,action
      file = File.open("config/routes.rb","a+")
      if file.readline("class Routes < WebitRoutes")
        file.write("\n\s\sget \'/#{controller_class_name}/#{action}\' do\n")
        file.write("\s\s\s\sgoto \'#{controller_class_name}\',\s\'#{action}\'\n")
        file.write("\s\send\n")
        file.close
      end
    end

    # method to create html file for the controller action
    def create_view_file action
      File.new("app/views/#{action}.html.erb","w")
    end

    # method to write sample template in html file of action
    def write_to_view controller_name,action
      file = File.open("app/views/#{action}.html.erb","a")
      file.write("<html>\n\s\s<body>\n\s\s\s\s<h1>\n")
      file.write("\s\s<%= \"You are in #{controller_name} Controller\'s #{action} Action\" %>\n")
      file.write("\s\s\s\s</h1>\n")
      file.write("\s\s</body>\n</html>\n")
      file.close
    end
end