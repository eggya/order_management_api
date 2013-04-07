require 'spec_helper'

describe LineItemsController do

  before(:each) do
    @product  = Factory(:product)
    @order    = Factory(:order)
  end

  def valid_attributes
    { "quantity" => 1, "product_id" => @product.id, "order_id" => @order.id}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all line_items as @line_items" do
      line_item = LineItem.create! valid_attributes
      get :index, {}, valid_session
      assigns(:line_items).should eq([line_item])
    end
  end

  describe "GET show" do
    it "assigns the requested line_item as @line_item" do
      line_item = LineItem.create! valid_attributes
      get :show, {:id => line_item.to_param}, valid_session
      assigns(:line_item).should eq(line_item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new LineItem" do
        expect {
          post :create, {:line_item => valid_attributes}, valid_session
        }.to change(LineItem, :count).by(1)
      end

      it "assigns a newly created line_item as @line_item" do
        post :create, {:line_item => valid_attributes}, valid_session
        assigns(:line_item).should be_a(LineItem)
        assigns(:line_item).should be_persisted
      end

      it "response should be success" do
        post :create, {:line_item => valid_attributes}, valid_session
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved line_item as @line_item" do
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, {:line_item => { "quantity" => "invalid value" }}, valid_session
        assigns(:line_item).should be_a_new(LineItem)
      end

      it "response should not be success" do
        LineItem.any_instance.stub(:save).and_return(false)
        post :create, {:line_item => { "quantity" => "invalid value" }}, valid_session
        response.should_not be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested line_item" do
        line_item = LineItem.create! valid_attributes

        LineItem.any_instance.should_receive(:update_attributes).with({ "quantity" => "1" })
        put :update, {:id => line_item.to_param, :line_item => { "quantity" => "1" }}, valid_session
      end

      it "assigns the requested line_item as @line_item" do
        line_item = LineItem.create! valid_attributes
        put :update, {:id => line_item.to_param, :line_item => valid_attributes}, valid_session
        assigns(:line_item).should eq(line_item)
      end

      it "response should be success" do
        line_item = LineItem.create! valid_attributes
        put :update, {:id => line_item.to_param, :line_item => valid_attributes}, valid_session
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns the line_item as @line_item" do
        line_item = LineItem.create! valid_attributes

        LineItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => line_item.to_param, :line_item => { "quantity" => "invalid value" }}, valid_session
        assigns(:line_item).should eq(line_item)
      end

      it "response should not be success" do
        line_item = LineItem.create! valid_attributes

        LineItem.any_instance.stub(:save).and_return(false)
        put :update, {:id => line_item.to_param, :line_item => { "quantity" => "invalid value" }}, valid_session
        response.should_not be_success
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested line_item" do
      line_item = LineItem.create! valid_attributes
      expect {
        delete :destroy, {:id => line_item.to_param}, valid_session
      }.to change(LineItem, :count).by(-1)
    end

    it "response should be success" do
      line_item = LineItem.create! valid_attributes
      delete :destroy, {:id => line_item.to_param}, valid_session
      response.should be_success
    end
  end

end
