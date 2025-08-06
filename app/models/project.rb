class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { maximum: 500 }
end
