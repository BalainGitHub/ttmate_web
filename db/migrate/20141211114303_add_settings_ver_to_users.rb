class AddSettingsVerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings_app_ver, :integer
    add_column :users, :settings_web_ver, :integer
  end
end
