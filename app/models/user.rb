class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :movies, dependent: :destroy

  def has_this_movie_name?(movie_name)
    movies.where(name: movie_name).present?
  end

end
