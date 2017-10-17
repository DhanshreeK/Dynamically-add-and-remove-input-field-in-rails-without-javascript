class ItemsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @item = @product.items.create(item_params)
    redirect_to product_path(@product)
  end

  def destroy
    @product = Product.find(params[:product_id])
    @item = @product.items.find(params[:id])
    @item.destroy
    redirect_to product_path(@product)
  end
 
  private
    def item_params
      params.require(:item).permit(:item_name,:price,:quantity,:product_id)
    end
end
