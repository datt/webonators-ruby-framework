#!/usr/bin/ruby
module FileRead
  def self.read_file
    arr = []
    File.open("post.rb", "r") do |file_pointer|
      file_pointer.each_line do |line|
        if line.start_with? "class"
          file_pointer.each_line {|content| arr.push(content) unless content.start_with? "end"}
        end
      end
    end
    temp_arr = []                        #tempory array for removing new line and blank spaces in array
    arr.each do |element|
      temp = element.gsub(/\n|\s/,"")     #tempory valiable which holds array elements without new line character
      temp_arr.push(temp)                 #pushing elements to tempory array
    end
    parameter_array = []
    temp_arr.each do |data|
      temp = data.split(":")
      parameter_array.push(temp)
    end
    parameter = Hash[parameter_array]
    parameter
  end

  def self.get_classname
    classname = []
    File.open("post.rb", "r") do |file_pointer|
      file_pointer.each_line do |line|
        if line.start_with? "class"
          classname = line.split(" ")
        end
      end
    end
    class_name = classname[1]
    class_name
  end
end