require 'spec_helper'

describe Order do
  
  it { should validate_presence_of(:order_date) }
  it { should have_many(:products).through(:line_items) }
  it { should have_many(:line_items) }

  describe "Methods" do
    before(:each) { @order = Factory(:order) }

    describe "update_net_total" do
      it "should be true with exsisting line_items" do
        @order.update_net_total.should be_true
      end
    end

    describe "update_net_gross" do
      it "should be true with exsisting line_items" do
        @order.update_gross_total.should be_true
      end
    end
  end
end