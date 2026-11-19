class CreateFeedbackMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :feedback_messages do |t|
      t.string :name
      t.string :email
      t.text :message
      t.boolean :handled, default: false, null: false

      t.timestamps
    end
  end
end
