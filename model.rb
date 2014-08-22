module Model
	
	def self.get_model_parameter 
			file_name = method_name
			if file_name.eql? "empty"
				puts "File can't be created"
			else
				puts file_name
				write_model = File.new(file_name,"a") 
				model_name = ARGV[1]
				model_name = model_name.downcase
				model_class_name = model_name.capitalize
				write_model.write "class #{model_class_name}\n"
				write_model.write "  def create_#{model_name}\t #auto generated\n"
				write_model.write "  end\n"
				write_model.write "end"
				write_model.close
			end
	end

	def self.method_name
		create_model_flag = false
		file_name = "empty"
			if ARGV[0].eql?("new")
				unless ARGV[1].eql?("")
					file_name = ARGV[1].downcase
					file_name = "#{file_name}.rb"
					create_file = File.new(file_name,"w")
					create_file.close
				end
				create_model_flag = true
				return file_name
			end
			if create_model_flag.eql? 0
				puts "Sorry new keyword is missing"
				return file_name
			end
	end
end
Model.get_model_parameter