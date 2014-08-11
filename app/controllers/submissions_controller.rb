class SubmissionsController < ApplicationController

  def create
    @submission = current_user.submissions.new(submissions_params)
    if @submission.save
      redirect_to task_path(@submission.question.task)
    else

    end
  end

  private

    def submissions_params
      params.require(:submission).permit(:question_id, :option_id)
    end
end
