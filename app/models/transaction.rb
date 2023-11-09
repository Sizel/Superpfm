class Transaction < ApplicationRecord
  belongs_to :account

  validates :transaction_id, :status, :made_on, :currency_code, :amount, :account_id, presence: true
  validates :transaction_id, uniqueness: true
end
