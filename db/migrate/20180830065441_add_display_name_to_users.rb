class AddDisplayNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :display_name, :string, limit: 191
    DbTextSearch::CaseInsensitive.add_index connection, :users, :display_name,
                                            unique: true
  end
end
