require 'spec_helper'

describe Order do
  
  describe "Associations" do
    it { should have_many(:products).through(:line_items) }
    it { should have_many(:line_items) }
  end

  describe "Callbacks" do

    describe 'validations' do
      it { should validate_presence_of(:order_date) }
    end
  end

  describe "Methods" do
    describe "update_net_total" do
      context "without existing line_items" do
        before { @order = Factory(:order) }

        it "should be true" do
         @order.update_net_total.should be_true
        end
      end

      context "with existing line_items" do
        before { @line_item = Factory(:line_item) }

        it "should be true" do
         @line_item.order.update_net_total.should be_true
        end
      end
    end

    describe "update_gross_total" do
      context "without existing line_items" do
        before { @order = Factory(:order) }

        it "should be true" do
         @order.update_gross_total.should be_true
        end
      end

      context "with existing line_items" do
        before { @line_item = Factory(:line_item) }

        it "should be true" do
         @line_item.order.update_gross_total.should be_true
        end
      end
    end
  end
end