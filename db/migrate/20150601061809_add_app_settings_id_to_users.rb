class AddAppSettingsIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :app_settings_id, :integer
  end
end
