class AddDetailsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :other_ids_1, :string, :limit => 40
  	add_column :users, :other_ids_2, :string, :limit => 40
  	add_column :users, :other_ids_3, :string, :limit => 40
  	add_column :users, :status, :string, :limit => 12
  end
end
