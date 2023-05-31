class AddCityToGuitars < ActiveRecord::Migration[7.0]
  def change
    add_column :guitars, :rental_city, :string
  end
end
