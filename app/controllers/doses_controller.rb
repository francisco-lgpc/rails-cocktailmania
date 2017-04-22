class DosesController < ApplicationController
  before_action :set_dose, only: :destroy
  before_action :set_dose_new, except: :destroy
  before_action :set_cocktail

  def new
  end

  def create
    @dose.cocktail = @cocktail
    ingredient_id = params[:dose][:ingredient_id]
    @dose.ingredient = Ingredient.find(ingredient_id) if ingredient_id != ""
    if @dose.save
      redirect_to cocktail_path(@cocktail)
    else
      render "cocktails/show"
    end
  end

  def destroy
    @dose.destroy
    redirect_to cocktail_path(@cocktail)
  end

  private

  def set_dose
    @dose = Dose.find(params[:id])
  end

  def set_dose_new
    @dose = Dose.new(dose_params)
  end

  def set_cocktail
    @cocktail = Cocktail.find(params[:cocktail_id])
  end

  def dose_params
    params.require(:dose).permit(:description)
  end
end
