class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile, limit: 20
      t.string :email, limit: 30
      t.string :first_name, limit: 20
      t.string :last_name, limit: 20
      t.integer :age
      t.string :gender, limit: 12
      t.text :home_address, limit: 250

      t.timestamps
    end
    add_index :users, :mobile, unique: true
    add_index :users, :email, unique: true
  end
end
