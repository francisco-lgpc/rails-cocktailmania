class AddPictureToCocktails < ActiveRecord::Migration[5.0]
  def change
    add_column :cocktails, :picture, :string
  end
end
