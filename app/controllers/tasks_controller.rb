class TasksController < ApplicationController
  before_action :authenticate!

  def show
    @task = Task.find(params[:id])
    @questions = @task.questions
    
    @submission = current_user.submissions.new

    @constructs = @questions.map do |question|
      QuestionConstructor.new(current_user, question).tap do |c|
        c.construct(:subject)
        c.construct(:references) if question.construct_meta.key?("references")
      end
    end

  end

end
