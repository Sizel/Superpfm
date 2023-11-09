class ConnectionsController < ApplicationController
  before_action :authenticate_user!

  def create
    response = SaltedgeClient.new.create_connection(current_user.customer_id)

    redirect_to_connect_url(response)
  end

  def destroy
    DestroyConnectionJob.perform_later(params[:id])

    redirect_to root_path
  end

  def refresh
    connection = Connection.find_by(connection_id: params[:id])
    connection.update!(next_refresh_possible_at: nil)

    RefreshConnectionJob.perform_later(params[:id])

    redirect_to root_path
  end

  def reconnect
    response = SaltedgeClient.new.reconnect_connection(params[:id])

    redirect_to_connect_url(response)
  end

  private

  def redirect_to_connect_url(response)
    redirect_to(response["data"]["connect_url"], allow_other_host: true)
  end

  def handle_refresh_not_possible_error(error)
    body = JSON.parse(error.response.body)

    return unless body["error"]["class"] == "ConnectionCannotBeRefreshed"

    Connection.find_by(connection_id: params[:id]).update!(next_refresh_possible_at: body["next_refresh_possible_at"])
  end
end
