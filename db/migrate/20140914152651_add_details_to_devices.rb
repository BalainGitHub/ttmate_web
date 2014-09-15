class AddDetailsToDevices < ActiveRecord::Migration
  def change
  	add_column :devices, :mobile, :string, :limit => 18
  	add_column :devices, :status, :string, :limit => 12
  	add_column :devices, :other_value_1, :string, :limit => 40
  	add_column :devices, :other_value_2, :string, :limit => 60
  	add_column :devices, :other_value_3, :string, :limit => 40
  	add_column :devices, :gcm_id, :string, :limit => 260

  	add_index :devices, :mobile
  end
end
