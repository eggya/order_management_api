class AddDesriptionToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :description, :text, :default => ''
  end
end
