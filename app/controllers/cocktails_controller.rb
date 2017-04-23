class CocktailsController < ApplicationController
  before_action :set_cocktail, only: [:edit, :show, :update]

  def index
    @cocktails = Cocktail.where.not(picture: nil)
  end

  def show
    @dose = Dose.new
  end

  def new
    @dose = Dose.new
    @cocktail = Cocktail.new
  end

  def edit
    @dose = Dose.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    @cocktail.name = params[:cocktail][:name].split.map(&:capitalize).join(' ') if @cocktail.name
    @cocktail.picture = "" if @cocktail.photo?
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
    @search = true
    if params[:query] == ""
      @cocktails = @cocktails = Cocktail.where.not(picture: nil)
    else
      @cocktails = Cocktail.where(name: params[:query].split.map(&:capitalize).join(' '))
      if @cocktails.empty?
        ingredients = Ingredient.where(name: params[:query].capitalize)

        @cocktails = Cocktail.all.reject { |c| c.ingredients - ingredients == c.ingredients }
      end
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

