class CreateSearchHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :search_histories do |t|
      t.string :user_token, null: false
      t.string :location, null: false

      t.timestamps
    end
    add_index :search_histories, [:user_token, :location], unique: true
  end
end
