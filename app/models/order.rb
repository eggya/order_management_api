class Order < ActiveRecord::Base
  attr_accessible :status, :order_date, :description

  validates_presence_of :order_date
  validates_presence_of :description, :if => Proc.new{ |p| p.status == 3 }
  
  validate :order_date_is_of_the_past
  validate :status_update, :on => :update, :if => Proc.new{ |p| p.status_changed? }
  validate :order_is_draft?, :on => :update

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

  # only draft order can be modified
  def order_is_draft?
    errors.add(:order, "is placed") unless status == 0 || (status != 0 && status_changed?)
  end

  # making sure order_date < today
  def order_date_is_of_the_past
    errors.add(:order_date, "is not valid") unless !order_date.nil? && order_date < Date.today
  end

  # only called on status attribute update
  # status constant are stored on lib/initializer/constans.rb
  # STATUS = { 0 => 'Draft', 1 => 'Placed', 2 => 'Paid', 3 => 'Cancelled' }
  def status_update
    case status_was
      when 0 then return (status == 1 && line_items.length > 0) || (status == 3)
      when 1 then return (status == 2) || (status == 3)
    end
    
    errors.add(:status, "illegal activity")
  end
end