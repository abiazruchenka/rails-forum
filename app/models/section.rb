class Section < ApplicationRecord
  has_many :chapters, dependent: :destroy
end
