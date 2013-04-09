class LineItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity

  validates_presence_of :order_id, :product_id, :quantity
  validates_numericality_of :quantity, :greater_than => 0

  belongs_to :order
  belongs_to :product

  before_save     :calculate_net_price, :order_is_changeable?
  after_save      :calculate_net_total, :calculate_gross_total

  before_destroy  :order_is_changeable?
  after_destroy   :calculate_net_total, :calculate_gross_total

  def product_name
    product.name
  end

private

  # only line_item with draft order can be modified
  def order_is_changeable?
    order.status == 0
  end

  # updates line_item's price according to qty
  def calculate_net_price
    self.net_total = quantity * Product.find(product_id).price
  rescue
    errors.add(:product, "is not valid")
    false
  end

  # recalculate order's net_total as new line_item saved
  def calculate_net_total
    order.update_net_total
  end

  # recalculate order's gross_total as new line_item saved
  def calculate_gross_total
    order.update_gross_total
  end
end