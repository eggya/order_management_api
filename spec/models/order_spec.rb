require 'spec_helper'

describe Order do
  it { should validate_presence_of(:order_date) }

  it { should have_many(:products).through(:line_items) }
  it { should have_many(:line_items) }
end