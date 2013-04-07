class OrdersController < ApplicationController

  def index
    @orders = Order.all

    render json: @orders
  end

  def show
    @order = Order.find(params[:id])

    render json: @order
  end

  def create
    @order = Order.new(params[:order])

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])

    if @order.update_attributes(params[:order])
      head :no_content
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
end
