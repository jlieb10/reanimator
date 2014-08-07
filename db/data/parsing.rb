require 'json'
require 'yaml'

# Method to  reformat files to arrays of objects since the data provided was lacking adequate syntax

def reformat_files_as_arrays(*files)
  files.each do |file|
    File.open(file,'r') do |f|
      array = []
      f.each do |line|
        object = JSON.parse(line)
        array << object
      end
      File.open(File.join(File.dirname(f.path),"reformatted_#{File.basename(f.path)}"), 'w') do |newfile|
        JSON.dump(array, newfile)
      end
    end
  end
end

def convert_yaml_to_json(file)
  File.open(file, 'r') do |f|
    object = YAML.load(f)
    File.open(File.join(File.dirname(f.path),"reformatted_#{File.basename(f.path, ".yml")}.json"), 'w') do |newfile|
      JSON.dump(object, newfile)
    end
  end
end


# reformat_files_as_arrays(*Dir['./*.json'])
#convert_yaml_to_json(*Dir['./*.yml'])
