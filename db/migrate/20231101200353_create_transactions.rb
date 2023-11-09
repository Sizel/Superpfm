class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :transaction_id, null: false
      t.string :status, null: false
      t.datetime :made_on, null: false
      t.string :currency_code, null: false
      t.decimal :amount, null: false
      t.string :description
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
