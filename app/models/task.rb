class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 300 }
  validates :priority, inclusion: { in: %w[normal high urgent], allow_nil: true }
  validate :due_date_cannot_be_in_the_past, on: :create

  # Scopes - AJOUT DU SCOPE ORDERED ICI
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :urgent, -> { where(priority: 'urgent') }
  scope :high_priority, -> { where(priority: 'high') }
  scope :overdue, -> { pending.where("due_date < ?", Date.current) }
  scope :due_soon, -> { pending.where(due_date: Date.current..7.days.from_now) }
  scope :recent, -> { order(created_at: :desc) }
  scope :ordered, -> { order(:position, :created_at) }  # <-- LE SCOPE MANQUANT
  scope :by_priority, -> {
    order(
      Arel.sql("CASE priority
                WHEN 'urgent' THEN 1
                WHEN 'high' THEN 2
                WHEN 'normal' THEN 3
                ELSE 4
              END"),
      due_date: :asc
    )
  }

  # Callbacks
  before_create :set_default_priority
  before_create :set_position

  # Methods
  def overdue?
    !completed? && due_date.present? && due_date < Date.current
  end

  def due_today?
    due_date == Date.current
  end

  def status
    if completed?
      'completed'
    elsif overdue?
      'overdue'
    elsif due_today?
      'due_today'
    else
      'pending'
    end
  end

  def priority_label
    case priority
    when 'urgent' then '🔴 Urgent'
    when 'high' then '🟡 Important'
    else '🟢 Normal'
    end
  end

  # Réorganiser les tâches
  def insert_at_position(new_position)
    old_position = position
    return if old_position == new_position

    if new_position < old_position
      # Déplacement vers le haut
      project.tasks.where(position: new_position...old_position)
                   .update_all("position = position + 1")
    else
      # Déplacement vers le bas
      project.tasks.where(position: (old_position + 1)..new_position)
                   .update_all("position = position - 1")
    end

    update_column(:position, new_position)
  end

  private

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.current
      errors.add(:due_date, "ne peut pas être dans le passé")
    end
  end

  def set_default_priority
    self.priority ||= 'normal'
  end

  def set_position
    self.position = project.tasks.maximum(:position).to_i + 1
  end
end
