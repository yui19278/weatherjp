class Search < ActiveRecord::Migration[7.2]
  def change
    drop_table :search_histories
    drop_table :searh_histories
  end
end
