class RefreshConnectionJob < ApplicationJob
  queue_as :default

  def perform(connection_id)
    SaltedgeClient.new.refresh_connection(connection_id)
  rescue RestClient::NotAcceptable => e
    handle_refresh_not_possible_error(e, connection_id)
  end

  private

  def handle_refresh_not_possible_error(error, connection_id)
    body = JSON.parse(error.response.body)

    return unless body["error"]["class"] == "ConnectionCannotBeRefreshed"

    Connection.find_by(connection_id:).update!(next_refresh_possible_at: body["next_refresh_possible_at"])
  end
end
