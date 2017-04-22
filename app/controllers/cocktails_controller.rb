class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:edit, :show, :update]

  def index
    @cocktails = Cocktail.all
  end

  def show
    @dose = Dose.new
  end

  def new
    @cocktail = Cocktail.new
  end

  def edit
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      redirect_to @cocktail, notice: 'cocktail was successfully created.'
    else
      render :new
    end
  end

  def update
    if @cocktail.update(cocktail_params)
      redirect_to @cocktail, notice: 'cocktail was successfully updated.'
    else
      render :edit
    end
  end

  def search
    @cocktails = Cocktail.where(name: params[:query].capitalize)
    if @cocktails.empty?
      ingredients = Ingredient.where(name: params[:query].capitalize)

      @cocktails = Cocktail.all.reject { |c| c.ingredients - ingredients == c.ingredients }
    end
    render :index
  end

  private

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def cocktail_params
    params.require(:cocktail).permit(:name, :picture, :photo)
  end
end

