class SubmissionsController < ApplicationController

  def create
    current_user.submissions.create(submissions_params)
    
  end

  private
  def submissions_params
    params.require(:submission).permit(:question_option_id)
  end
end
