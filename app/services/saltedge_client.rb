# frozen_string_literal: true

class SaltedgeClient
  BASE_URL = 'https://www.saltedge.com/api/v5'

  attr_reader :app_id, :secret

  def initialize
    @app_id = Rails.application.credentials[Rails.env.to_sym].dig(:se, :app_id)
    @secret = Rails.application.credentials[Rails.env.to_sym].dig(:se, :secret)
  end

  def create_customer(identifier)
    request(:post, "#{BASE_URL}/customers", payload: { data: { identifier: } })
  end

  def create_connection(customer_id)
    payload = {
      data: {
        customer_id:,
        provider_code: "fakebank_simple_xf",
        consent: consent_payload
      }
    }

    request(:post, "#{BASE_URL}/connect_sessions/create", payload:)
  end

  def get_connection(connection_id)
    request(:get, "#{BASE_URL}/connections/#{connection_id}")
  end

  def get_accounts(connection_id)
    request(:get, "#{BASE_URL}/accounts?connection_id=#{connection_id}")
  end

  def get_transactions(connection_id, account_id)
    request(:get, "#{BASE_URL}/transactions?connection_id=#{connection_id}&account_id=#{account_id}")
  end

  def refresh_connection(connection_id)
    payload = {
      data: {
        attempt: {
          fetch_scopes: %w[accounts transactions]
        }
      }
    }

    request(:put, "#{BASE_URL}/connections/#{connection_id}/refresh", payload:)
  end

  def delete_connection(connection_id)
    request(:delete, "#{BASE_URL}/connections/#{connection_id}")
  end

  def reconnect_connection(connection_id)
    payload = {
      data: {
        connection_id:,
        consent: consent_payload
      }
    }

    request(:post, "#{BASE_URL}/connect_sessions/reconnect", payload:)
  end

  private

  def consent_payload
    {
      from_date: "2020-05-08",
      period_days: 90,
      scopes: %w[account_details transactions_details]
    }
  end

  def request(method, url, params = {})
    response = RestClient::Request.execute(
      method:,
      url:,
      payload: params[:payload].to_json,
      headers: {
        'Accept' => 'application/json',
        'Content-type' => 'application/json',
        'App-Id' => app_id,
        'Secret' => secret
      }
    )

    JSON.parse(response.body)
  rescue RestClient::Exception => e
    Rails.logger.error("Error: #{e.message}, Response: #{e.response}")

    raise
  end
end
