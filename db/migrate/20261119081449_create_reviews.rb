class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps
      t.index [ :user_id, :car_id ], unique: true
    end
  end
end
