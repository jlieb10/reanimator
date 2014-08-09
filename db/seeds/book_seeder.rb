class BookSeeder

  class << self
    attr_accessor :oclc_files, :gutenberg_files

    def run
      parse_files(oclc_files)      { |data| seed_from_oclc(data) }
      parse_files(gutenberg_files) { |data| seed_from_gutenberg(data) }
    end

    def parse_files files
      [files].flatten.each do |file|
        raw_data  = File.read(file)
        data_hash = JSON.parse(raw_data)
        yield(data_hash)
      end
    end

    def seed_from_gutenberg(books)
      books.each do |book|
        handle_gutenberg_hash(book)
      end
    end

    def seed_from_oclc(books)
      books.each do |book|
        handle_oclc_hash(book)
      end
    end

    def handle_oclc_hash(hash)
      OclcBook.create do |b|
        b.nid      = hash["id"]
        b.language = hash["language"]

        b.titles       << handle_potential_inconsistency(hash["title"])
        b.descriptions << handle_potential_inconsistency(hash["description"])
      end
    end

    def handle_gutenberg_hash(hash)
      GutenbergBook.create do |b|
        b.nid      = hash["id"]
        b.subtitle = hash["subtitle"]
        b.titles  << hash["title"]
        b.language = hash["language"]
        b.authors  = hash["authors"].map { |a| a["name"] }

        hash.each do |key, value|
          if /links?_(?<link_type>\w+)/ =~ key && !value.blank?
            b.links[link_type.to_sym] = value
          end
        end
      end
    end


    def handle_potential_inconsistency(value)
      case value
      when Array
        value.map do |h|
          if h.is_a? Hash
            h["@value"]
          else
            h
          end
        end
      when String
        value
      end
    end
  end
end