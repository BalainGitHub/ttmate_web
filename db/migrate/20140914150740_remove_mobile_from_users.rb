class RemoveMobileFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :mobile, :string
  end
end
