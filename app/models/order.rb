class Order < ActiveRecord::Base
  attr_accessible :status, :total, :total_billed, :order_date

  validates_presence_of :order_date
  validate :order_date_is_of_the_past

  has_many :products, :through => :line_items
  has_many :line_items

  # performed as line_item saved
  def update_net_total
    update_attribute( 
      :net_total, line_items.collect(&:net_total).compact.inject{ |sum,price| sum += price }
    )
  end

  # performed as line_item saved
  def update_gross_total
    update_attribute(
      :gross_total, net_total + (net_total * VAT)
    )
  end

private

  # making sure order_date < today
  def order_date_is_of_the_past
    errors.add(:order_date, "is not valid") unless !order_date.nil? && order_date < Date.today
  end
end