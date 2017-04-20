# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

COCKTAILS = %w(
  Bramble
  Alexander
  Aviation
  Bijou
  Bloodhound
  Bronx
  Casino
  Derby
  Gibson
  Gimlet
)

URL = "http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"

Cocktail.destroy_all
Ingredient.destroy_all

ingredients_json = open(URL).read
ingredients_parsed = JSON.parse(ingredients_json)

ingredients = []

ingredients_parsed["drinks"].uniq.each do |ing|
  ingredients << Ingredient.create(name: ing.values.first)
end


COCKTAILS.each do |cockatail_name|
  cocktail = Cocktail.create(name: cockatail_name)

  ingredients_temp_arr = ingredients
  5.times do
    ingredient = ingredients_temp_arr.delete(ingredients_temp_arr.sample)
    cocktail.ingredients << ingredient
  end
end

Dose.all.each { |dose| dose.description = "100 ml"; dose.save! }
