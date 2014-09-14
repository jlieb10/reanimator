class TasksController < ApplicationController
  before_action :authenticate!

  def show

    @task = Task.find(params[:id])
    @questions = @task.questions
    
    @submission = current_user.submissions.new

    @constructs = @questions.map do |question|
      QuestionConstructor.new(current_user, question).tap do |qc|
        qc.generate_references
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

end
