require 'spec_helper'

describe LineItem do

  describe 'Associations' do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe 'Callbacks' do
    
    before do
      @order   = Factory(:order)
      @product = Factory(:product)
    end

    describe 'validations' do  
      it { should validate_presence_of(:order_id) }
      it { should validate_presence_of(:product_id) }
      it { should validate_presence_of(:quantity) }
      it { should validate_numericality_of(:quantity) }
    end

    describe 'before_save' do
      describe 'calculate_net_price' do
        context 'when product is found' do
          it 'should calculate_net_price' do
            line_item = LineItem.new 'order_id' => @order.id, 'product_id' => @product.id, 'quantity' => 2
            line_item.send(:calculate_net_price).should == @product.price * 2
          end
        end

        context 'when product is not found' do
          it 'should return false as net_total' do
            line_item = LineItem.new 'order_id' => @order.id, 'product_id' => 21, 'quantity' => 2
            line_item.send(:calculate_net_price).should eq(false)
          end
        end
      end

      describe 'order_is_changeable?' do
        before { @line_item = Factory(:line_item) }

        context 'when order is draft (status=0)' do
          it 'should be able to save' do
            @line_item.update_attribute(:quantity,1).should be_true
          end
        end

        context 'when order is not draft (status!=0)' do
          it 'should not be able to save when satus is placed (status==1)' do
            @line_item.order.update_attribute(:status,1)
            @line_item.update_attribute(:quantity,1).should_not be_true
          end
        end
      end
    end

    describe 'after_save' do
      before { @line_item = Factory(:line_item) }

      describe 'calculate_net_total' do
        context 'when new object created' do
          it 'should update line_item\'s order net total' do
            @line_item.order.net_total.should == @line_item.net_total
          end
        end

        context 'when object updated' do
          it 'should update line_item\'s order net total' do
            @line_item.order.net_total.should == @line_item.net_total
          end
        end
      end

      describe 'calculate_gross_total' do
        context 'when new object created' do
          it 'should update line_item\'s order net total' do
            @line_item.order.gross_total.should == @line_item.net_total + ( @line_item.order.net_total * VAT )
          end
        end

        context 'when object updated' do
          it 'should update line_item\'s order net total' do
            @line_item.order.gross_total.should == @line_item.net_total + ( @line_item.order.net_total * VAT )
          end
        end
      end
    end
  end

  describe 'Methods' do

    before { @line_item = Factory(:line_item) }

    describe 'product_name' do
      it 'has to return a product name when line item retrieve' do
        @line_item.product_name == @line_item.product.name
      end
    end
  end
end