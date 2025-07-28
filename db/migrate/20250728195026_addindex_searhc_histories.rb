class AddindexSearhcHistories < ActiveRecord::Migration[7.2]
  def change
    change_column_null :search_histories, :user_token, false
    change_column_null :search_histories, :location,   false

    add_index :search_histories, [:user_token, :location], unique: true, name: "index_search_histories_on_user_and_location"
  end
end
