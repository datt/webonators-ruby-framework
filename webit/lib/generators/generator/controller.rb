require ::File.expand_path("../../../webit/webit_controller.rb", __FILE__)
require 'fileutils'

class Controller

  def call_for_controller_operations argv
    actions = []
    controller_name = argv[2]
    if argv[2].nil?
      puts "Controller Name is not defined"
    else
      if controller_name[controller_name.length-1]!='s'
        controller_name="#{controller_name}s"
      end
      create_controller_class controller_name
      if argv.length > 3
        argv.each_with_index do |action, index|
          if index > 2
            action = action.downcase
            actions << action
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

    def create_controller_class controller_name
      controller_name = controller_name.downcase
      controller_class_name = controller_name.split('_').each {|word| word.capitalize!}
      controller_class_name = controller_class_name.join.concat("Controller")
      write_controller = File.new("app/controllers/#{controller_name}_controller.rb","w")
      write_controller.write "class #{controller_class_name} < WebitController\n"
      write_controller.close
    end

    def endfile_condition controller_name
      write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a")
      write_controller.write "\nend"
      write_controller.close
      write_routes = File.open("config/routes.rb","a")
      write_routes.write("\nend")
      write_routes.close
    end

    def write_def_controller controller_name,action
      write_controller = File.open("app/controllers/#{controller_name}_controller.rb","a+")
      write_controller.write("\n\s\sdef #{action}\n\s\send\n")
      write_controller.close
    end

    def write_action_routes controller_class_name,action
      file = File.open("config/routes.rb","a+")
      if file.readline("class Routes < WebitRoutes")
        file.write("\n\s\sget \'/#{controller_class_name}/#{action}\' do\n")
        file.write("\s\s\s\sgoto \'#{controller_class_name}\',\s\'#{action}\'\n")
        file.write("\s\send\n")
        file.close
      end
    end

    def create_view_file action
      File.new("app/views/#{action}.html.erb","w")
    end

    def write_to_view controller_name,action
      file = File.open("app/views/#{action}.html.erb","a")
      file.write("<html>\n\s\s<body>\n\s\s\s\s<h1>\n")
      file.write("\s\s<%= \"You are in #{controller_name} Controller\'s #{action} Action\" %>\n")
      file.write("\s\s\s\s</h1>\n")
      file.write("\s\s</body>\n</html>\n")
      file.close
    end
end