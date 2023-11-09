class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :account_id, null: false
      t.decimal :balance, null: false
      t.string :currency_code, null: false
      t.string :name, null: false
      t.string :nature, null: false
      t.string :status
      t.references :connection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
