class TasksController < ApplicationController
  before_action :authenticate!

  def show
    @task = Task.find(params[:id])
    
  end

end
