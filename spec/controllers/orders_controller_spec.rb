require 'spec_helper'

describe OrdersController do

  def valid_attributes
    { "status" => 1 }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all orders as @orders" do
      order = Order.create! valid_attributes
      get :index, {}, valid_session
      assigns(:orders).should eq([order])
    end
  end

  describe "GET show" do
    it "assigns the requested order as @order" do
      order = Order.create! valid_attributes
      get :show, {:id => order.to_param}, valid_session
      assigns(:order).should eq(order)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Order" do
        expect {
          post :create, {:order => valid_attributes}, valid_session
        }.to change(Order, :count).by(1)
      end

      it "assigns a newly created order as @order" do
        post :create, {:order => valid_attributes}, valid_session
        assigns(:order).should be_a(Order)
        assigns(:order).should be_persisted
      end

      it "response should be success" do
        post :create, {:order => valid_attributes}, valid_session
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved order as @order" do
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:order => { "status" => "invalid value" }}, valid_session
        assigns(:order).should be_a_new(Order)
      end

      it "response should not be success" do
        Order.any_instance.stub(:save).and_return(false)
        post :create, {:order => { "status" => "invalid value" }}, valid_session
        response.should_not be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested order" do
        order = Order.create! valid_attributes

        Order.any_instance.should_receive(:update_attributes).with({ "status" => "1" })
        put :update, {:id => order.to_param, :order => { "status" => "1" }}, valid_session
      end

      it "assigns the requested order as @order" do
        order = Order.create! valid_attributes
        put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
        assigns(:order).should eq(order)
      end

      it "response should be success" do
        order = Order.create! valid_attributes
        put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns the order as @order" do
        order = Order.create! valid_attributes
        Order.any_instance.stub(:save).and_return(false)
        put :update, {:id => order.to_param, :order => { "status" => "invalid value" }}, valid_session
        assigns(:order).should eq(order)
      end

      it "response should not be success" do
        order = Order.create! valid_attributes
        Order.any_instance.stub(:save).and_return(false)
        put :update, {:id => order.to_param, :order => { "status" => "invalid value" }}, valid_session
        response.should_not be_success
      end
    end
  end
end