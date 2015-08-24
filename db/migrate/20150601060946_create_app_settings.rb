class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.string :version
      t.text :setting_data

      t.timestamps
    end
  end
end
