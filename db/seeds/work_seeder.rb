class WorkSeeder
  class << self
    attr_accessor :work_files, :equivalency_files

    def run
      parse_files(work_files)       { |data| seed_works(data) }
      parse_files(equivalency_files) { |data| seed_equivalency(data) }
    end

    def parse_files files
      [files].flatten.each do |file|
        raw_data = File.read(file)
        parsed_data = JSON.parse(raw_data)

        yield(parsed_data)
      end
    end

    def seed_works(works)
      works.each do |obj|
        OclcWork.create(:nid => obj["id"])
      end
    end

    def seed_equivalency(equivalencies)
      equivalencies.each do |equivalency|
        book_id, work_id, confidence = equivalency
        book_type = "#{book_id.split('-').first.downcase.camelcase}Book"

        Equivalency.create do |eq|
          eq.oclc_work_nid = work_id
          eq.book_nid      = book_id
          eq.book_type     = book_type
          eq.confidence    = confidence
        end
      end
    end
  end
end