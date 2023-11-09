class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :connections

  before_create :create_customer

  private

  def create_customer
    return if customer_id.present?

    response         = SaltedgeClient.new.create_customer(email)
    self.customer_id = response["data"]["id"]
  end
end
