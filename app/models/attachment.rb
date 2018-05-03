class Attachment < ApplicationRecord
  has_attached_file :attach_body, :styles => { :large => "500x500>", :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :attach_body, :content_type => /\Aimage\/.*\Z/
end
