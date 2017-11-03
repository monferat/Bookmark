class AddSnapshotColumnsToBookmarkers < ActiveRecord::Migration[5.1]
  def up
    add_attachment :bookmarkers, :snapshot
  end

  def down
    remove_attachment :bookmarkers, :snapshot
  end
end
