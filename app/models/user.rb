class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :large => "400x400>", :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :likes

  # почему админ integer? почему просто не определить его boolean и использовать рельсовый admin? И это код для view?
  def group
    self.admin == 1 ? 'Administrator' : 'User'
  end

  # Форматирование представления данных - работа View слоя. Это код хелперов, ника не модели
  def registered
    self.created_at.strftime('%v %T')
  end

  # Аналогично
  def birthdate
    self.birth_date.strftime('%v') if self.birth_date
  end

  # где ассоциации? имя метода некорректно, метод возвращаяет count, а не коллекцию
  # has_many :messages
  # delegate :count, to: :message, prefix: true
  # и на выходе получим message_count метод.
  # А в идеале такие вещи решаются просто использованием counter_cache
  def all_by_author
    Message.where(user_id: self.id).count
  end

  # Та же претензия.
  # Зачем здесь try?
  def likes_count
    Like.where(author_id: self.id).try(:count)
  end
end
