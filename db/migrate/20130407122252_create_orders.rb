class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :status,     :null => false, :default => 0
      t.float :total,        :null => false, :default => 0
      t.float :total_billed, :null => false, :default => 0

      t.timestamps
    end
  end
end