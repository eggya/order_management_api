class RenameTotalBilledIntoGrossTotalInOrder < ActiveRecord::Migration
  def up
    rename_column :orders, :total_billed, :gross_total
  end

  def down
    rename_column :orders, :gross_total, :total_billed
  end
end
