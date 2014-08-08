# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'yaml'
require 'pp'

tasks = YAML.load(File.read(File.join(__dir__, 'data', 'tasks.yml')))


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


