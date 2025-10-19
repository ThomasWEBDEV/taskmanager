class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  # Méthodes Helper
  def display_name
    email.split('@').first.capitalize
  end

  # Vous pouvez ajouter ici la méthode productivity_score si elle existe
  # def productivity_score
  #   # Logique de calcul du score
  # end
end
