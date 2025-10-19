class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete_all_tasks]

  def index
    @projects = current_user.projects.includes(:tasks)
  end

  def show
    # Correction : utiliser le scope ordered défini dans le modèle Task
    @tasks = @project.tasks.includes(:user).ordered
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to @project, notice: "Projet créé avec succès ! 🚀"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Projet mis à jour avec succès ! ✨"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Projet supprimé avec succès."
  end

  def complete_all_tasks
    count = @project.tasks.where(completed: false).update_all(completed: true)
    redirect_to @project, notice: "#{count} tâches marquées comme terminées ! 🎉"
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
