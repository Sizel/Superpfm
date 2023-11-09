class DestroyConnectionFromDbJob < ApplicationJob
  queue_as :default

  def perform(webhook_data)
    Connection.find_by(connection_id: webhook_data["connection_id"]).destroy!
  end
end
