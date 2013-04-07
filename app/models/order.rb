class Order < ActiveRecord::Base
  attr_accessible :status, :total, :total_billed, :order_date

  validates_presence_of :order_date
  validate :order_date_is_of_the_past

  has_many :products, :through => :line_items
  has_many :line_items

private

  def order_date_is_of_the_past
    errors.add(:order_date, "is not valid") unless !order_date.nil? && order_date < Date.today
  end
end