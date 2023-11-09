class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = Account.find(params[:account_id]).transactions
  end
end
