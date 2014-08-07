class TasksController < ApplicationController
  
  def show
    @task = Task.find(params[:id])
  end


  private

  def task_params
    params.require(:task).permit (:category, :point_value, :name)
  end
end
