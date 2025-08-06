class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 300 }
end
