require 'json'
require 'yaml'

# Method to  reformat files to arrays of objects since the data provided was lacking adequate syntax

def reformat_json_files_as_arrays(*files)
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

def convert_json_to_yaml(files, dump_dir=nil)
  files.each do |file|
    json_obj = JSON.parse(File.read(file))
    dump_dir ||= File.dirname(file)
    file_name = File.basename(file, '.json')
    File.open(File.join(dump_dir, "#{file_name}.yaml"), 'w') do |new_file|
      new_file << YAML.dump(json_obj)
    end
  end
end

# reformat_files_as_arrays(*Dir['./*.json'])
#convert_yaml_to_json(*Dir['./*.yml'])

convert_json_to_yaml(Dir[File.join(__dir__,'/data/*.json')], File.join(__dir__,'/data/yaml'))
