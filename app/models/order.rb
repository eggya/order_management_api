class Order < ActiveRecord::Base
  attr_accessible :status, :total, :total_billed

  has_many :products, :through => :line_items
  has_many :line_items
end
