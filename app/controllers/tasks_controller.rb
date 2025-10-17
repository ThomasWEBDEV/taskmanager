class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @tasks = current_user.tasks.includes(:project)

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @tasks = @tasks.where("title ILIKE ? OR description ILIKE ?", search_term, search_term)
    end

    case params[:status]
    when 'pending'
      @tasks = @tasks.where(completed: false)
    when 'completed'
      @tasks = @tasks.where(completed: true)
    end
    
    @tasks = @tasks.order(created_at: :desc)
  end

  def show
  end

  def new
    @project = current_user.projects.find(params[:project_id])
    @task = @project.tasks.build
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "❌ Projet non trouvé."
  end

  def create
    @project = current_user.projects.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    @task.user = current_user
    @task.completed = false
    
    if @task.save
      redirect_to @project, notice: "✅ Tâche ajoutée avec succès!"
    else
      flash.now[:alert] = "❌ Impossible de créer la tâche. Veuillez corriger les erreurs."
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "❌ Projet non trouvé."
  end

  def update
    if @task.update(completed: !@task.completed)
      status = @task.completed ? "terminée ✅" : "réactivée 🔄"
      redirect_to @task.project, notice: "Tâche #{status}"
    else
      redirect_to @task.project, alert: "❌ Impossible de mettre à jour la tâche."
    end
  end

  def destroy
    project = @task.project
    @task.destroy
    redirect_to project, notice: "🗑️ Tâche supprimée avec succès!"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "❌ Tâche non trouvée."
  end

  def task_params
    params.require(:task).permit(:title, :description, :completed, :due_date, :priority, :notes)
  end
end
