class Chapter < ApplicationRecord
  has_many :topics, dependent: :destroy

  def topics_count
    self.topics.count
  end

  def posts
    messages.count
  end

  def last_post
    last_message = last_chapter_message
    last_post_info = {message: last_message.try(:posted)}
    user_id = last_message.try(:user_id)
    topic = message_topic(last_message.topic_id) if last_message

    user = user_by_id(user_id) if user_id

    last_post_info[:user] = user
    last_post_info[:user_name] = user.try(:user_name)
    last_post_info[:topic_title] = topic.try(:title)
    last_post_info[:topic] = topic

    return last_post_info
  end

  private

  def user_by_id(user_id)
    User.find(user_id)
  end

  def messages
    Message.where(chapter_id: self.id)
  end

  def message_topic(id)
    Topic.find(id)
  end

  def last_chapter_message
    messages.order(created_at: :asc).last
  end

end
