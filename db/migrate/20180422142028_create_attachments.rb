class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.has_attached_file :attach_body
      t.belongs_to :message, index: true
      t.timestamps
    end
  end
end
