require 'spec_helper'

describe LineItemsController do

  before(:each) do
    @product  = Factory(:product)
    @order    = Factory(:order)
  end

  def valid_attributes
    Factory.attributes_for(:line_item, order_id: @order.id, product_id: @order.id)
  end

  describe "GET index" do
    before { @line_item = LineItem.create! valid_attributes }

    it "assigns all line_items as @line_items" do
      get :index, {}
      assigns(:line_items).should eq([@line_item])
    end
  end

  describe "GET show" do
    before { @line_item = LineItem.create! valid_attributes }

    it "assigns the requested line_item as @line_item" do
      get :show, {:id => @line_item.to_param}
      assigns(:line_item).should eq(@line_item)
    end
  
    it "shows product name as one of the attribute" do
      get :show, {:id => @line_item.to_param}
      assigns(:line_item).product_name.should eq(@line_item.product.name)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      
      context "when order is a draft (status==0)" do
        it "creates a new LineItem" do
          expect {
            post :create, {:line_item => valid_attributes}
          }.to change(LineItem, :count).by(1)
        end

        it "assigns a newly created line_item as @line_item" do
          post :create, {:line_item => valid_attributes}
          assigns(:line_item).should be_a(LineItem)
          assigns(:line_item).should be_persisted
        end

        it "updates the value of net_total" do
          post :create, {:line_item => valid_attributes}
          assigns(:line_item).net_total.should == @product.price * assigns(:line_item).quantity
        end

        it "updates order\'s net_total and gross_total values" do
          post :create, {:line_item => valid_attributes}
          assigns(:line_item).order.net_total.should == assigns(:line_item).net_total
          assigns(:line_item).order.gross_total.should == assigns(:line_item).net_total + ( assigns(:line_item).net_total * VAT )
        end

        it "response should be success" do
          post :create, {:line_item => valid_attributes}
          response.should be_success
        end
      end

      context "when order is placed (status == 1)" do
        before { @order.update_attribute(:status,1) }

        it "response should not be success" do
          post :create, { :line_item => valid_attributes }
          response.should_not be_success
        end
      end

      context "when order is paid (status == 2)" do
        before { @order.update_attribute(:status,2) }

        it "response should not be success" do
          post :create, { :line_item => valid_attributes }
          response.should_not be_success
        end
      end

      context "when order is cancelled (status == 3)" do
        before { @order.update_attribute(:status,3) }

        it "response should not be success" do
          post :create, { :line_item => valid_attributes }
          response.should_not be_success
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved line_item as @line_item" do
        post :create, {:line_item => { "quantity" => "invalid value" }}
        assigns(:line_item).should be_a_new(LineItem)
      end

      it "response should not be success" do
        post :create, {:line_item => { "quantity" => "invalid value", "product_id" => "invalid_value" }}
        response.should_not be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before { @line_item = LineItem.create! valid_attributes }

      context "when order is draft (status==0)" do
        it "updates the requested line_item" do
          LineItem.any_instance.should_receive(:update_attributes).with({ "quantity" => "1" })
          put :update, {:id => @line_item.to_param, :line_item => { "quantity" => "1" }}
        end

        it "assigns the requested line_item as @line_item" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          assigns(:line_item).should eq(@line_item)
        end

        it "updates the value of net_total" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          assigns(:line_item).net_total.should == @product.price * @line_item.quantity
        end

        it "updates order\'s net_total and gross_total values" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          assigns(:line_item).order.net_total.should == assigns(:line_item).net_total
          assigns(:line_item).order.gross_total.should == assigns(:line_item).net_total + ( assigns(:line_item).net_total * VAT )
        end

        it "response should be success" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          response.should be_success
        end
      end

      context "when order is placed (status==1)" do
        before { @order.update_attribute(:status,1) }

        it "response should not be success" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          response.should_not be_success
        end
      end

      context "when order is placed (status==2)" do
        before { @order.update_attribute(:status,2) }

        it "response should not be success" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          response.should_not be_success
        end
      end

      context "when order is placed (status==3)" do
        before { @order.update_attribute(:status,3) }

        it "response should not be success" do
          put :update, {:id => @line_item.to_param, :line_item => valid_attributes}
          response.should_not be_success
        end
      end
    end

    describe "with invalid params" do
      before { @line_item = LineItem.create! valid_attributes }

      context "when order is draft" do
        it "assigns the line_item as @line_item" do
          put :update, {:id => @line_item.to_param, :line_item => { "quantity" => "invalid value" }}
          assigns(:line_item).should eq(@line_item)
        end

        it "response should not be success" do
          put :update, {:id => @line_item.to_param, :line_item => { "quantity" => "invalid value" }}
          response.should_not be_success
        end
      end

      context "when order is not draft" do
        before { @order.update_attribute(:status, 1) }

        it "response should not be success" do
          put :update, {:id => @line_item.to_param, :line_item => { "quantity" => "invalid value" }}
          response.should_not be_success
        end
      end
    end
  end

  describe "DELETE destroy" do
    before { @line_item = LineItem.create! valid_attributes }

    context "when order is draft (status == 0)" do
      it "destroys the requested line_item" do
        expect {
          delete :destroy, {:id => @line_item.to_param}
        }.to change(LineItem, :count).by(-1)
      end

      it "updates order\'s net_total and gross_total values" do
        delete :destroy, {:id => @line_item.to_param}
        @order.net_total.should == 0.0
        @order.gross_total.should == 0
      end

      it "response should be success" do
        delete :destroy, {:id => @line_item.to_param}
        response.should be_success
      end
    end

    context "when order is placed (status == 1)" do
      before { @order.update_attribute(:status,1) }

      it "response should not be success" do
        expect {
          delete :destroy, {:id => @line_item.to_param}
        }.to change(LineItem, :count).by(0)
      end
    end

    context "when order is placed (status == 2)" do
      before { @order.update_attribute(:status,2) }

      it "response should not be success" do
        expect {
          delete :destroy, {:id => @line_item.to_param}
        }.to change(LineItem, :count).by(0)
      end
    end

    context "when order is placed (status == 3)" do
      before { @order.update_attribute(:status,3) }

      it "response should not be success" do
        expect {
          delete :destroy, {:id => @line_item.to_param}
        }.to change(LineItem, :count).by(0)
      end
    end
  end
end