class AddNetTotalToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :net_total, :float, :default => 0
  end
end
