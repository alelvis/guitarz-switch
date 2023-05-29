class CreateGuitars < ActiveRecord::Migration[7.0]
  def change
    create_table :guitars do |t|
      t.string :name
      t.string :brand
      t.string :model
      t.string :description
      t.string :material
      t.string :pickup
      t.boolean :right_handed
      t.integer :year
      t.string :country
      t.integer :price_per_day
      t.references :user

      t.timestamps
    end
  end
end
