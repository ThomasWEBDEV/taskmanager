class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.includes(:project)

    if params[:search].present?
      @tasks = @tasks.where("title ILIKE ? OR description ILIKE ?",
                          "%#{params[:search]}%", "%#{params[:search]}%")
    end

    case params[:status]
    when 'pending'
      @tasks = @tasks.where(completed: false)
    when 'completed'
      @tasks = @tasks.where(completed: true)
    end
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
    @task.update(completed: true)
    redirect_to @task.project
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    project = @task.project
    @task.destroy
    redirect_to project
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date, :priority, :notes)
  end
end
