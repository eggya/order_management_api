require 'spec_helper'

describe LineItem do
  it { should belong_to(:order) }
  it { should belong_to(:product) }

  it { should validate_presence_of(:order_id) }
  it { should validate_presence_of(:product_id) }
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity) }
end