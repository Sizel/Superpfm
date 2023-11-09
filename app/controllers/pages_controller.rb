class PagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @connections = current_user.connections
  end
end
