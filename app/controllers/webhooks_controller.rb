class WebhooksController < ApplicationController
  skip_forgery_protection
  before_action :parse_webhook_data

  def import_data
    ImportDataJob.perform_later(@webhook_data) if fetching_data_finished?

    head :ok
  end

  def destroy
    DestroyConnectionFromDbJob.perform_later(@webhook_data)

    head :ok
  end

  private

  def parse_webhook_data
    @webhook_data = JSON.parse(request.body.read)["data"]
  end

  def fetching_data_finished?
    @webhook_data["stage"] == "finish" || @webhook_data["error_class"].present?
  end
end
