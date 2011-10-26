class AddImportantToStep < ActiveRecord::Migration
  def self.up
    add_column :steps, :important, :boolean, :default=>"0"
  end

  def self.down
    remove_column :steps, :important
  end
end
