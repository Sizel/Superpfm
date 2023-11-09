class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = Connection.find(params[:connection_id]).accounts
  end
end
