class CreateTestDrives < ActiveRecord::Migration[8.1]
  def change
    create_table :test_drives do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true
      t.datetime :scheduled_at
      t.integer :status, default: 0, null: false
      t.string :phone
      t.text :comment

      t.timestamps
    end
  end
end
