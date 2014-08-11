class TasksController < ApplicationController
  
  def show
    @tasks = Task.where(category: params[:category])
  end

end
