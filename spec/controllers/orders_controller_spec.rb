require 'spec_helper'

describe OrdersController do

  def valid_attributes
    Factory.attributes_for(:order, 'order_date' => Date.today - 1.day)
  end

  describe "GET index" do
    it "assigns all orders as @orders" do
      order = Order.create! valid_attributes
      get :index, {}
      assigns(:orders).should eq([order])
    end
  end

  describe "GET show" do
    it "assigns the requested order as @order" do
      order = Order.create! valid_attributes
      get :show, {:id => order.to_param}
      assigns(:order).should eq(order)
    end
  end

  describe "POST create" do
    context "when order status is not stated" do
      describe "with valid params" do
        it "creates a new Order" do
          expect {
            post :create, {:order => valid_attributes}
          }.to change(Order, :count).by(1)
        end

        it "assigns a newly created order as @order" do
          post :create, {:order => valid_attributes}
          assigns(:order).should be_a(Order)
          assigns(:order).should be_persisted
        end

        it "response should be success" do
          post :create, {:order => valid_attributes}
          response.should be_success
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved order as @order" do
          Order.any_instance.stub(:save).and_return(false)
          post :create, {:order => { "status" => "invalid value" }}
          assigns(:order).should be_a_new(Order)
        end

        it "response should not be success" do
          Order.any_instance.stub(:save).and_return(false)
          post :create, {:order => { "status" => "invalid value" }}
          response.should_not be_success
        end
      end
    end

    context "when status defined as anything but 0" do
      it "response should not be success with status = 1" do
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:order => Factory.attributes_for(:order, status:1)}
        response.should_not be_success
      end

      it "response should not be success with status = 2" do
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:order => Factory.attributes_for(:order, status:2)}
        response.should_not be_success
      end

      it "response should not be success with status = 3" do
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:order => Factory.attributes_for(:order, status:3)}
        response.should_not be_success
      end
    end

    context "when order_date is beyond today" do
      it "response should not be success" do
        order = Order.create! valid_attributes
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:id => order.to_param, :order => { "order_date" => Date.today+1.day }}
        response.should_not be_success
      end
    end
  end

  describe "PUT update" do
    context "when update in general" do
      describe "with valid params" do
        
        context "when order is draft" do
          it "updates the requested order" do
            order = Order.create! valid_attributes

            Order.any_instance.should_receive(:update_attributes).with({ "status" => "1" })
            put :update, {:id => order.to_param, :order => { "status" => "1" }}
          end

          it "assigns the requested order as @order" do
            order = Order.create! valid_attributes
            put :update, {:id => order.to_param, :order => valid_attributes}
            assigns(:order).should eq(order)
          end

          it "response should be success" do
            order = Order.create! valid_attributes
            put :update, {:id => order.to_param, :order => valid_attributes}
            response.should be_success
          end
        end

        context "when order is not draft" do
          it "response should not be success" do
            order = Order.create! valid_attributes
            order.update_attribute(:status,1)
            put :update, {:id => order.to_param, :order => { :order_date => Date.today-2.days }}
            response.should_not be_success
          end
        end
      end

      describe "with invalid params" do
        context "when status is invalid" do
          it "assigns the order as @order" do
            order = Order.create! valid_attributes
            Order.any_instance.stub(:save).and_return(false)
            put :update, {:id => order.to_param, :order => { "status" => "invalid value" }}
            assigns(:order).should eq(order)
          end

          it "response should not be success" do
            order = Order.create! valid_attributes
            Order.any_instance.stub(:save).and_return(false)
            put :update, {:id => order.to_param, :order => { "status" => "invalid value" }}
            response.should_not be_success
          end
        end

        context "when order_date is beyond today" do
          it "assigns the order as @order" do
            order = Order.create! valid_attributes
            Order.any_instance.stub(:save).and_return(false)
            put :update, {:id => order.to_param, :order => { "order_date" => Date.today+1.day }}
            assigns(:order).should eq(order)
          end

          it "response should not be success" do
            order = Order.create! valid_attributes
            Order.any_instance.stub(:save).and_return(false)
            put :update, {:id => order.to_param, :order => { "order_date" => Date.today+1.day }}
            response.should_not be_success
          end
        end
      end
    end

    context "when updating status" do
      context "when updating status from draft" do
        before(:each) { @order = Factory(:line_item).order }

        it 'should allow changes from 0 to 1' do
          put :update, {:id => @order.to_param, :order => { :status => 1 }}
          response.should be_success
        end

        it 'should allow changes from 0 to 3' do
          put :update, {:id => @order.to_param, :order => { 'status' => 3, 'description' => 'description' }}
          response.should be_success
        end

        it 'should not allow changes from 0 to 2' do
          put :update, {:id => @order.to_param, :order => { 'status' => 2 }}
          response.should_not be_success
        end

        it 'should not allow changes from 0 to anything beyond 3' do
          put :update, {:id => @order.to_param, :order => { 'status' => 4 }}
          response.should_not be_success
        end
      end

      context "when updating status from placed" do
        before(:each) do
          @order = Factory(:order)
          @order.update_attribute(:status,1)
        end

        it 'should allow changes from 1 to 2' do
          put :update, {:id => @order.to_param, :order => { 'status' => 2 }}
          response.should be_success
        end

        it 'should allow changes from 1 to 3' do
          put :update, {:id => @order.to_param, :order => { 'status' => 3, 'description' => 'description' }}
          response.should be_success
        end

        it 'should not allow changes from 1 to 0' do
          put :update, {:id => @order.to_param, :order => { 'status' => 0 }}
          response.should_not be_success
        end

        it 'should not allow changes from 1 to anything beyond 3' do
          put :update, {:id => @order.to_param, :order => { 'status' => 4 }}
          response.should_not be_success
        end
      end

      context "when updating status from paid" do
        before(:each) do
          @order = Factory(:order)
          @order.update_attribute(:status,1)
          @order.update_attribute(:status,2)
        end

        it 'should not allow changes from 2 to 3' do
          put :update, {:id => @order.to_param, :order => { 'status' => 3 }}
          response.should_not be_success
        end
      end
    end
  end
end