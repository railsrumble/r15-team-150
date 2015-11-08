class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_latest_uploads, dependent: :destroy

  def create_chrome_app_session_id
    sha = Digest::SHA1.hexdigest([Time.now, rand].join) 
    update_attributes(chrome_app_session_id: sha)
    return chrome_app_session_id
  end
end
