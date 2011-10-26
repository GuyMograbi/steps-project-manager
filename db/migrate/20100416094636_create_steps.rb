class CreateSteps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.string :title
      t.text :description
      t.integer :parent_id
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
