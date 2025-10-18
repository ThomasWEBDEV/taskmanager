class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :update, :destroy, :reorder, :toggle_complete]

  def index
    @tasks = current_user.tasks.includes(:project)

    # Recherche
    if params[:search].present?
      @tasks = @tasks.where("tasks.title ILIKE ? OR tasks.description ILIKE ?",
                          "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Filtrage par statut
    case params[:status]
    when 'pending'
      @tasks = @tasks.pending
    when 'completed'
      @tasks = @tasks.completed
    end

    # Tri
    @tasks = @tasks.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "tasks-results",
          partial: "tasks/list",
          locals: { tasks: @tasks }
        )
      }
    end
  end

  def show
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
      redirect_to @project, notice: "Tâche ajoutée avec succès ! ✅"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @task.update(completed: true)
    redirect_to @task.project, notice: "Tâche marquée comme terminée ! 👏"
  end

  def destroy
    project = @task.project
    @task.destroy
    redirect_to project, notice: "Tâche supprimée."
  end

  def reorder
    @task.insert_at_position(params[:position].to_i)
    head :ok
  end

  def toggle_complete
    @task.update(completed: !@task.completed)
    
    message = @task.completed? ? "Tâche terminée ! 👏" : "Tâche réouverte."
    
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace(
            "task_#{@task.id}",
            partial: "tasks/task",
            locals: { task: @task }
          ),
          turbo_stream.prepend(
            "toast-container",
            partial: "shared/toast",
            locals: { message: message, type: "success" }
          )
        ]
      }
      format.html { redirect_to @task.project, notice: message }
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date, :priority, :notes)
  end
end
