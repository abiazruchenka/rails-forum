class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.integer :order, null: false
      t.belongs_to :topic, index: true
      t.belongs_to :chapter, index: true
      t.belongs_to :user, index: true
      t.string :status
      t.timestamps
    end
  end
end
