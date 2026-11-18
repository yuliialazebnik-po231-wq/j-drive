class CreateBranches < ActiveRecord::Migration[8.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :city
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
