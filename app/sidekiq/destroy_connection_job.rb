class DestroyConnectionJob < ApplicationJob
  queue_as :default

  def perform(connection_id)
    SaltedgeClient.new.delete_connection(connection_id)
  end
end
