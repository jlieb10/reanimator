module TasksHelper
  def task_accordion_button(category)
    tasks = Task.send("in_#{category}")
    real_category = tasks.first.category
    render 'partials/task_accordion_dropdown', :tasks => tasks, :category => real_category
  end
end
