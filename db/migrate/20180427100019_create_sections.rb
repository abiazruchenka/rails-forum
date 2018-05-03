class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections do |t|
      t.string :title, null: false
      t.belongs_to :user, index: true
      t.string :status, null: false
      t.timestamps
    end
  end
end
