class Topic < ApplicationRecord

  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :messages

  def answers
    topic_id = self.id
    all_messages = messages_by_topic_id(topic_id).count
    all_messages - 1 if all_messages > 0
  end

  def topic_author
    user_by_id(self.user_id)
  end

  def last_post
    last_message = last_topic_message
    last_post_info = {message: last_message.try(:posted)}
    user_id = last_message.try(:user_id)
    user = user_by_id(user_id) if user_id
    last_post_info[:user] = user
    last_post_info[:user_name] = user.try(:user_name)
    return last_post_info
  end

  def editable?(current_user)
    (self.answers == 0 && current_user.id.equal?(self.user_id)) || current_user.try(:admin)
  end

  private

  def user_by_id user_id
    User.find(user_id)
  end

  def last_topic_message
    topic_id = self.id
    messages_by_topic_id(topic_id).order(created_at: :asc).last
  end

  def messages_by_topic_id(topic_id)
    Message.where(topic_id: topic_id)
  end

end
