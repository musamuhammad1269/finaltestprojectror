class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end

  has_one_attached :image
  acts_as_voter  

  has_one_attached :avatar


  after_commit :add_default_avatar, on: %i[create update]


  def avatar_thumbnail
    if avatar.attached?
      avatar.variant(resize: "150x150!").processed 
    else
      "/default_profile.jpg"
    end
  end
  

  private
  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app' , 'assets', 'images', 'default_profile.jpg'
          )
        ), filename: 'default_profile.jpg',
        content_type: 'image/jpg'
      )
    end
  end

  


end
