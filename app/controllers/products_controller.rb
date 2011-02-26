class ProductsController < ApplicationController
  
  def index
    @products = Product.all
  end

  def show(loaded_product)
  end

  def new
    @product = Product.new
  end

  def edit(loaded_product)
  end

  def create(product)
    if @product.save
      redirect_to(@product, :notice => 'Product was successfully created.')
    else
      render :action => "new"
    end
  end

  def update(loaded_product)
    if @product.update_attributes(params[:product])
      redirect_to(@product, :notice => 'Product was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy(loaded_product)
    @product.destroy
    redirect_to(products_url)
  end
end
