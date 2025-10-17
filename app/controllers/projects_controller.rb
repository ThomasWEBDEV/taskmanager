class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete_all_tasks]

  def index
    @projects = current_user.projects.includes(:tasks)
  end

  def show
    @tasks = @project.tasks.includes(:user)
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)
    
    if @project.save
      redirect_to @project, notice: "✨ Projet créé avec succès!"
    else
      flash.now[:alert] = "❌ Impossible de créer le projet. Veuillez corriger les erreurs."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "✅ Projet mis à jour avec succès!"
    else
      flash.now[:alert] = "❌ Impossible de mettre à jour le projet."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "🗑️ Projet supprimé avec succès!"
  end

  def complete_all_tasks
    count = @project.tasks.where(completed: false).update_all(completed: true)
    
    if count > 0
      redirect_to @project, notice: "🎉 #{count} tâche(s) marquée(s) comme terminée(s)!"
    else
      redirect_to @project, alert: "⚠️ Aucune tâche à terminer."
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "❌ Projet non trouvé."
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
