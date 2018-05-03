class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.belongs_to :chapter, index: true
      t.string :description
      t.string :title, null: false
      t.string :status, null: false
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
