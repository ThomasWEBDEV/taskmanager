class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def new
    @project = current_user.projects.find(params[:project_id])
    @task = @project.tasks.new
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @task = @project.tasks.new(task_params)
    @task.user = current_user
    @task.completed = false
    if @task.save
      redirect_to @project
    else
      render :new
    end
  end

  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to @task.project
    else
      render :edit
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to @task.project
  end


  private
  def task_params
    params.require(:task).permit(:title, :description, :completed)
  end
end
