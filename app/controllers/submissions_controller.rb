class SubmissionsController < ApplicationController

  def create
    @submission = current_user.submissions.new(submission_params)
    respond_to do |format|

      if @submission.save
        format.html { redirect_to task_path(@submission.question.task) }
        format.js { redirect_to task_path(@submission.question.task) }
      else

      end

    end
  end

  private

    def submission_params
      params.require(:submission).permit(:question_id, :option_id, :references_attributes => [:referenced_nid, :referenced_type, :column_name, :role])
    end
end
