class CreateChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chapters do |t|
      t.string :title, null: false
      t.string :description
      t.belongs_to :user, index: true
      t.belongs_to :section, index: true
      t.string :status, null: false
      t.timestamps
    end
  end
end
