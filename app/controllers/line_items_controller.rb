class LineItemsController < ApplicationController

  def index
    @line_items = LineItem.all
    render json: @line_items.to_json({:methods => :product_name})
  end

  def show
    @line_item = LineItem.find(params[:id])
    render json: @line_item.to_json({:methods => :product_name})
  end

  def create
    @line_item = LineItem.new(params[:line_item])

    if @line_item.save
      render json: @line_item, status: :created, location: @line_item
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  def update
    @line_item = LineItem.find(params[:id])

    if @line_item.update_attributes(params[:line_item])
      head :no_content
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    head :no_content
  end
end
