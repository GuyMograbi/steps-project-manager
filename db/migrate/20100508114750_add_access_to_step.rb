class AddAccessToStep < ActiveRecord::Migration
  def self.up
    add_column :steps ,:access , :string, :default => 'inherit'
  end

  def self.down
    remove_column :steps, :access
  end
end
