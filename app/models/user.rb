class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

# Je configure les relations dans le model
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy
end
