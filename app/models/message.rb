class Message < ApplicationRecord

  has_many :likes, dependent: :destroy

  # delegate
  def author_user_name
    author.user_name
  end

  def author_avatar
    author.avatar.url(:thumb)
  end

  # delegate
  def author_address
    author.address
  end

  # delegate
  def all_by_author
    author.all_by_author
  end

  # Я уже видел этот код в user.rb
  def user_author
    author.admin ? 'Administrator' : 'User'
  end

  # Снова форматирование дат в моделях
  def posted
    self.try(:created_at).strftime('%v %T')
  end

  def updated
    self.try(:updated_at).strftime('%v %T')
  end

  # Ассоциация
  def author
    User.find(self.user_id)
  end

end
