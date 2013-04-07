class LineItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity

  validates_presence_of :order_id,:product_id,:quantity
  validates_numericality_of :quantity, :greater_than => 0

  belongs_to :order
  belongs_to :product
end