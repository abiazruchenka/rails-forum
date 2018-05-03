class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :large => "400x400>", :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :likes

  def group
    self.admin == 1 ? 'Administrator' : 'User'
  end

  def registered
    self.created_at.strftime('%v %T')
  end

  def birthdate
    self.birth_date.strftime('%v') if self.birth_date
  end

  def all_by_author
    Message.where(user_id: self.id).count
  end

  def likes_count
    Like.where(author_id: self.id).try(:count)
  end
end
