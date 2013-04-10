require 'spec_helper'

describe ProductsController do

  def valid_attributes
    Factory.attributes_for(:product)
  end

  describe "GET index" do
    it "assigns all products as @products" do
      product = Product.create! valid_attributes
      get :index, {}
      assigns(:products).should eq([product])
    end
  end

  describe "GET show" do
    it "assigns the requested product as @product" do
      product = Product.create! valid_attributes
      get :show, {:id => product.to_param}
      assigns(:product).should eq(product)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Product" do
        expect {
          post :create, {:product => valid_attributes}
        }.to change(Product, :count).by(1)
      end

      it "assigns a newly created product as @product" do
        post :create, {:product => valid_attributes}
        assigns(:product).should be_a(Product)
        assigns(:product).should be_persisted
      end

      it "response should be success" do
        post :create, {:product => valid_attributes}
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved product as @product" do
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => { "name" => "invalid value" }}
        assigns(:product).should be_a_new(Product)
      end

      it "response should not be success" do
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => { "name" => "invalid value" }}
        response.should_not be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested product" do
        product = Product.create! valid_attributes

        Product.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => product.to_param, :product => { "name" => "MyString" }}
      end

      it "assigns the requested product as @product" do
        product = Product.create! valid_attributes
        put :update, {:id => product.to_param, :product => valid_attributes}
        assigns(:product).should eq(product)
      end

      it "response should be success" do
        product = Product.create! valid_attributes
        put :update, {:id => product.to_param, :product => valid_attributes}
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns the product as @product" do
        product = Product.create! valid_attributes
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => { "name" => "invalid value" }}
        assigns(:product).should eq(product)
      end

      it "response should not be success" do
        product = Product.create! valid_attributes
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => { "name" => "invalid value" }}
        response.should_not be_success
      end
    end
  end

  describe "DELETE destroy" do
    context "without attached orders" do
      it "destroys the requested product" do
        product = Product.create! valid_attributes
        expect {
          delete :destroy, {:id => product.to_param}
        }.to change(Product, :count).by(-1)
      end

      it "response should be success" do
        product = Product.create! valid_attributes
        delete :destroy, {:id => product.to_param}
        response.should be_success
      end
    end

    context "with attached orders" do
      it "response should be success" do
        product   = Product.create! valid_attributes
        order     = Factory(:order)
        line_item = LineItem.create! :product_id => product.id, :order_id => order.id, :quantity => 1

        expect {
          delete :destroy, {:id => product.to_param}
        }.to change(Product, :count).by(0)
      end
    end
  end

end