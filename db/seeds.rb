# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


=begin

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

Cocktail.destroy_all
Ingredient.destroy_all

# Generate Ingredients

INGREDIENTS_URL = "http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"

ingredients_json = open(INGREDIENTS_URL).read
ingredients_parsed = JSON.parse(ingredients_json)

ingredients = []

ingredients_parsed["drinks"].uniq.each do |ing|
  ingredients << Ingredient.create(name: ing.values.first)
end

=end


# Generate Cocktails and Doses
ingredients = Ingredient.all

def ing_key?(k, v)
  k.index("strIngredient") && v != ""
end

def dose_key?(k, v)
  k.index("strMeasure") && v != ""
end

RANDOM_COCKTAIL_URL = "http://www.thecocktaildb.com/api/json/v1/1/random.php"
COCKTAIL_URL        = "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i="

11000.upto(18000) do |i|

  cocktail_json = open(COCKTAIL_URL + i.to_s).read
  cocktail_parsed = JSON.parse(cocktail_json)
  next if cocktail_parsed["drinks"].nil?
  cocktail_data = cocktail_parsed["drinks"].first

  next if Cocktail.find_by_name(cocktail_data["strDrink"])

  c = Cocktail.create(name: cocktail_data["strDrink"], picture: cocktail_data["strDrinkThumb"])
  ing = nil

  cocktail_data.select { |k, v| ing_key?(k, v)}.to_h.each_with_index do |(k, v), i|
    next if v.nil?
      ing = Ingredient.find_by_name(v) ? Ingredient.find_by_name(v) : Ingredient.create(name: v)
    next if c.ingredients.include?(ing)
    c.ingredients << ing

    dose = Dose.find_by_ingredient_id_and_cocktail_id(ing.id, c.id)
    dose.description = cocktail_data.select { |k, v| dose_key?(k, v)}.to_h.values[i].strip

    ing.doses << dose

  end

end
