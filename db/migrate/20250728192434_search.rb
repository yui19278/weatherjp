class Search < ActiveRecord::Migration[7.2]
  def change
    drop_table :search_histories, if_exists: true
    create_table :search_histories, if_not_exists: true do |t|
    t.string :user_token, null: false
    t.string :location,   null: false
    t.timestamps
  end
  add_index :search_histories, [:user_token, :location],
            unique: true, if_not_exists: true
  end
end
