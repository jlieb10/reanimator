Dir.glob(File.join(__dir__, 'seeds','*.rb')) do |file|
  # require all seed classes
  require file
end

data_dir = File.join(__dir__, 'data')

TaskSeeder.files             = Dir[File.join(data_dir, 'tasks.yml')]

BookSeeder.oclc_files        = Dir[File.join(data_dir, 'json', 'reformatted_oclc_edition.json')]
BookSeeder.gutenberg_files   = Dir[File.join(data_dir, 'json', 'reformatted_gutenberg.json')]

WorkSeeder.work_files        = Dir[File.join(data_dir, 'json', 'reformatted_oclc_work.json')]
WorkSeeder.equivalency_files = Dir[File.join(data_dir, 'json', 'reformatted_equivalency.json')]

[TaskSeeder, BookSeeder, WorkSeeder].each(&:run)