class Message < ApplicationRecord

  has_many :likes, dependent: :destroy

  def author_user_name
    author.user_name
  end

  def author_avatar
    author.avatar.url(:thumb)
  end

  def author_address
    author.address
  end

  def all_by_author
    author.all_by_author
  end

  def user_author
    author.admin ? 'Administrator' : 'User'
  end

  def posted
    self.try(:created_at).strftime('%v %T')
  end

  def updated
    self.try(:updated_at).strftime('%v %T')
  end

  def author
    User.find(self.user_id)
  end

end
