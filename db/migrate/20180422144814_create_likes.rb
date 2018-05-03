class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :message, index: true
      t.integer :author_id, index: true
      t.timestamps
    end
  end
end
