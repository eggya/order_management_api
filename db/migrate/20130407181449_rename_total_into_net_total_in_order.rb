class RenameTotalIntoNetTotalInOrder < ActiveRecord::Migration
  def up
    rename_column :orders, :total, :net_total
  end

  def down
    rename_column :orders, :net_total, :total
  end
end
