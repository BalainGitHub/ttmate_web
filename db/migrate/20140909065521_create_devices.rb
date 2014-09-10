class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :brand, limit: 15
      t.string :device_name, limit: 15
      t.string :model, limit: 15
      t.string :build_id, limit: 40
      t.string :product, limit: 20
      t.string :imei, limit: 60
      t.string :android_id, limit: 50
      t.string :sdk_version, limit: 15
      t.string :os_release, limit: 15
      t.integer :os_incremental
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
