class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.references :brand, null: false, foreign_key: true
      t.string :name
      t.integer :year
      t.decimal :price, precision: 10, scale: 2
      t.string :body_type
      t.string :engine
      t.integer :horsepower
      t.string :transmission
      t.string :drive
      t.string :color
      t.text :description
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
