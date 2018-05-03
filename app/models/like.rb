class Like < ApplicationRecord
  validates_uniqueness_of :user_id, scope: 'message_id'
end
