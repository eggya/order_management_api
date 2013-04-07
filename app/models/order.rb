class Order < ActiveRecord::Base
  attr_accessible :status, :total, :total_billed, :order_date

  validates_presence_of :order_date

  has_many :products, :through => :line_items
  has_many :line_items

  before_save :validate_order_date

private

  def validate_order_date
    return false if order_date.nil?
    order_date < Date.today() 
  end
end