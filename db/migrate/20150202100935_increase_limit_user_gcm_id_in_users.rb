class IncreaseLimitUserGcmIdInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :user_gcm_id, :string, :limit => 255
  end
end
