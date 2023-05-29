class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :guitar, null: false, foreign_key: true
      t.integer :price
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
