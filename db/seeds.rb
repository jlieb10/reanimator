# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
require 'pp'

module TaskSeeder

  module_function
    def seed(tasks)
      # task seeds
      tasks["tasks"].each do |task|
        Task.create do |t|
          t.name     = task["name"]
          t.category = task["category"]

        end.tap do |t|
          # after creating task
          task["questions"].each do |question|
            Question.create do |q|
              q.expectation = question["expectation"]
              q.content     = question["content"]
              q.task        = t
            end.tap do |q|
              # after creating question
              question["options"].each do |option|
                # try to reuse duplicated options
                Option.find_or_create_by(value: option["value"]).tap do |o|
                  
                  QuestionOption.create do |q_o|
                    q_o.option           = o
                    q_o.question         = q
                    q_o.additional_input = option["additional_input"] if option["additional_input"]
                  end
                end
              end

            end
          end
          
        end
      end
    end
end


module BookSeeder

  module_function
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
      Book.create do |b|
        b.type     = "OCLC"
        b.nid      = hash["id"]
        b.language = hash["language"]

        b.titles       << handle_potential_inconsistency(hash["title"])
        b.descriptions << handle_potential_inconsistency(hash["description"])
      end
    end

    def handle_gutenberg_hash(hash)
      Book.create do |b|
        b.type     = "Gutenberg"
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

data_dir            = File.join(__dir__, 'data')

raw_tasks           = File.read("#{data_dir}/tasks.yml")
raw_oclc_books      = File.read("#{data_dir}/json/reformatted_oclc_edition.json")
raw_gutenberg_books = File.read("#{data_dir}/json/reformatted_gutenberg.json")

tasks               = YAML.load(raw_tasks)
oclc_books          = JSON.parse(raw_oclc_books)
gutenberg_books     = JSON.parse(raw_gutenberg_books)

TaskSeeder.seed               (tasks)
BookSeeder.seed_from_oclc     (oclc_books)
BookSeeder.seed_from_gutenberg(gutenberg_books)

