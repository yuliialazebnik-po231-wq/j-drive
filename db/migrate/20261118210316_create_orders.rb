class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.decimal :total_price, precision: 10, scale: 2
      t.decimal :deposit_amount, precision: 10, scale: 2
      t.datetime :pickup_at
      t.integer :status, default: 0, null: false
      t.string :card_last4
      t.datetime :paid_at

      t.timestamps
    end
  end
end
