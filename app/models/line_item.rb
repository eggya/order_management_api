class LineItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity

  validates_presence_of :order_id, :product_id, :quantity
  validates_numericality_of :quantity, :greater_than => 0

  belongs_to :order
  belongs_to :product

  before_save :calculate_net_total

private

  def calculate_net_total
    self.net_total = quantity * Product.find(product_id).price
  rescue
    errors.add(:product, "is not valid")
    false
  end
end