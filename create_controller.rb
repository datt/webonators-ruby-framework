require 'fileutils'
module CreateController

  def self.read_command
    action=Array.new
    if ARGV[0].eql?("generate") && ARGV[1].eql?("controller")
      controller_name=ARGV[2]
      controller_name=controller_name.downcase

      if controller_name[controller_name.length-1]!='s'
        controller_name[controller_name.length]='s'
      end

      puts controller_name
      create_file_in_controller controller_name
      create_folder_in_view controller_name
      write_to_file_in_controller_without_actions controller_name

      command_length=ARGV.length
      if command_length > 3
        #write_to_file_in_controller_without_actions controller_name
        for  i in 3...command_length
          action=ARGV[i].downcase
          create_files_in_view controller_name,action
          write_action_in_controller controller_name,action
        end
      end
    end
  end

  def self.create_file_in_controller(controller_name)
    puts "in 2nd method"
    puts controller_name
    File.new("app/controllers/#{controller_name}_controller.rb","w")
  end

  def self.create_folder_in_view(controller_name)
    puts "in 3rd method"
    path = "app/views/#{controller_name}"
    FileUtils.mkdir_p(path) unless File.exists?(path)
  end

  def self.create_files_in_view(controller_name,action)
    #puts action
    File.new("app/views/#{controller_name}/#{action}.html.erb","w")
  end


  def self.write_action_in_controller(controller_name,action)

    file=File.open("app/controllers/#{controller_name}_controller.rb", "r+")
    controller_name_class = controller_name.capitalize
    if  file.readline("class #{controller_name} < ActionController::Base")
      file.write("\n\s\sdef\s#{action}\n\s\send")
    end
    file.write("\nend")
    file.close
  end

  def self.write_to_file_in_controller_with_actions(controller_name)
    controller_name_class = controller_name.capitalize
    file=File.open("app/controllers/#{controller_name}_controller.rb", "w")
    file.write("class #{controller_name_class} < ActionController::Base")
    file.write("\nend")
    file.close
  end

  def self.write_to_file_in_controller_without_actions(controller_name)
    controller_name_class = controller_name.capitalize
    file=File.open("app/controllers/#{controller_name}_controller.rb", "w")
    file.write("class #{controller_name_class} < ActionController::Base")
    #file.write("\nend")
    file.close
  end


end
CreateController.read_command