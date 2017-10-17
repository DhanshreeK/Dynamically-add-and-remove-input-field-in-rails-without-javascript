class ReceipesController < ApplicationController
   def index
    @receipes = Receipe.all
  end

  def show
    @receipe = Receipe.find(params[:id])
  end

  def new
    @receipe = Receipe.new
    @receipe.ingredients.build # build ingredient attributes, nothing new here
  end

  def create
    @receipe = Receipe.new(receipe_params)
    if params[:add_ingredient]
      # add empty ingredient associated with @recipe
      @receipe.ingredients.build
    elsif params[:remove_ingredient]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
    else
      # save goes like usual
      if @receipe.save
        flash[:notice] = "Successfully created recipe."
        redirect_to @receipe and return
      end
    end
    render :action => 'new'
  end

  def edit
    @receipe = Receipe.find(params[:id])
  end

  def update
    @receipe = Receipe.find(params[:id])
    if params[:add_ingredient]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:receipe][:ingredients_attributes].blank?
    for attribute in params[:receipe][:ingredients_attributes]
      @receipe.ingredients.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
    end
      end
      # add one more empty ingredient attribute
      @receipe.ingredients.build
    elsif params[:remove_ingredient]
      # collect all marked for delete ingredient ids
      removed_ingredients = params[:receipe][:ingredients_attributes].collect { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Ingredient.delete(removed_ingredients)
      flash[:notice] = "Ingredients removed."
      for attribute in params[:receipe][:ingredients_attributes]
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @recipe.ingredients.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      # save goes like usual
      if @recipe.update_attributes(params[:recipe])
        flash[:notice] = "Successfully updated recipe."
        redirect_to @recipe and return
      end
    end
    render :action => 'edit'
  end

  def add_ingredient
    @receipe = Receipe.find(params[:id])
    @receipe.ingredients.build
    render :edit
  end

  def destroy
    @receipe = Receipe.find(params[:id])
    @receipe.destroy
    flash[:notice] = "Successfully destroyed recipe."
    redirect_to receipes_url
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def receipe_params
      params.require(:receipe).permit(:name, :description,ingredients_attributes:[:name,:_destroy])
    end
end
