class Product < ActiveRecord::Base
  attr_accessible :name, :price
  
  validates_presence_of :name,:price
  validates_uniqueness_of :name
  validates_numericality_of :price

  has_many :orders, :through => :line_items
  has_many :line_items

  before_destroy :check_related_orders

private

  def check_related_orders
    return false if orders.count > 0
  end
end
