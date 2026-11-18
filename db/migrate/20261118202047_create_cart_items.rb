class CreateCartItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true

      t.timestamps
      t.index [ :cart_id, :car_id ], unique: true
    end
  end
end
