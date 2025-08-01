class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  #je configure les validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
end
