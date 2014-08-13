class TasksController < ApplicationController
  # before_action :authenticate!

  def show
    @task = Task.find(params[:id])
    @questions = @task.questions
    @constructs = @questions.map do |question| 
      QuestionConstruct.new(current_user, question).tap do |construct|
        construct.parse_meta(:subject)
        construct.parse_meta(:references) if question.construct_meta.key?("references")
      end
    end

  end

end
