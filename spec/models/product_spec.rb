require 'spec_helper'

describe Product do

  describe 'Associations' do
    it { should have_many(:orders).through(:line_items) }
    it { should have_many(:orders) }
  end

  describe 'Callbacks' do

    describe 'validations' do
      it { should validate_uniqueness_of(:name) }
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:price) }
      it { should validate_numericality_of(:price) }
    end

    describe 'before_save' do
      describe 'check_related_orders' do

        context 'when product is attached to an order' do
          before { @line_item = Factory(:line_item) }

          it 'should return false' do
            @line_item.product.send(:check_related_orders).should be_false
          end
        end

        context 'when product is not attached to any order' do
          before { @product = Factory(:product) }

          it 'should not return false' do
            @product.send(:check_related_orders).should be_nil
          end
        end
      end
    end
  end
end