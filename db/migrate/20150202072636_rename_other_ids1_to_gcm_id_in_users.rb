class RenameOtherIds1ToGcmIdInUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :other_ids_1, :user_gcm_id
  end
end
