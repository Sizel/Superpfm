class Account < ApplicationRecord
  belongs_to :connection
  has_many :transactions, dependent: :destroy

  validates :account_id, :balance, :currency_code, :name, :nature, :connection_id, presence: true
  validates :account_id, uniqueness: true
end
