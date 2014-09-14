require 'yaml'
class TaskSeeder
  class << self
    attr_accessor :files

    def run
      [self.files].flatten.each do |file|
        raw_tasks  = File.read(file)
        tasks_hash = YAML.load(raw_tasks)

        seed(tasks_hash)
      end
    end

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
              q.expectation    = question["expectation"]
              q.content        = question["content"]
              q.task           = t
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
end