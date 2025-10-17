class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, 
                    length: { minimum: 3, maximum: 100 },
                    uniqueness: { scope: :user_id, message: "Vous avez déjà un projet avec ce nom" }
  
  validates :description, length: { maximum: 500 }

  # Scopes
  scope :with_tasks, -> { includes(:tasks) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Méthodes
  def completion_percentage
    return 0 if tasks.empty?
    ((tasks.where(completed: true).count.to_f / tasks.count) * 100).round
  end
  
  def completed?
    tasks.any? && tasks.all?(&:completed?)
  end
  
  def pending_tasks_count
    tasks.where(completed: false).count
  end
  
  def urgent_tasks_count
    tasks.where(priority: 'urgent', completed: false).count
  end
end
