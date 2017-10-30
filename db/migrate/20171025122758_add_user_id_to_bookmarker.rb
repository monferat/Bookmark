class AddUserIdToBookmarker < ActiveRecord::Migration[5.1]
  def change
    add_column :bookmarkers, :user_id, :integer
  end
end
