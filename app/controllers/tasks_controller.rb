class TasksController < ApplicationController
  before_action :authenticate!

  def show
    @task = Task.find(params[:id])
    @questions = @task.questions
    @constructs = @questions.map { |q| QuestionConstruct.new(current_user, q) }    
    @constructs.each { |construct|  construct.parse_meta(:subject).parse_meta(:references) }
  end

end
