class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :name
      t.text :email
      t.text :message

      t.timestamps
    end
  end
end
