RSpec.describe SaltedgeClient do
  let(:client) { described_class.new }

  describe '#create_customer' do
    it 'creates a customer' do
      identifier = 'test_customer'

      expect(client).to receive(:request).with(
        :post,
        'https://www.saltedge.com/api/v5/customers',
        payload: { data: { identifier: } }
      )

      client.create_customer(identifier)
    end
  end

  describe '#create_connection' do
    it 'creates a connection' do
      customer_id = 'test_customer_id'

      expect(client).to receive(:request).with(
        :post,
        'https://www.saltedge.com/api/v5/connect_sessions/create',
        payload: {
          data: {
            customer_id:,
            provider_code: 'fakebank_simple_xf',
            consent: {
              from_date: '2020-05-08',
              period_days: 90,
              scopes: %w[account_details transactions_details]
            }
          }
        }
      )

      client.create_connection(customer_id)
    end
  end

  describe '#get_connection' do
    it 'gets a connection' do
      connection_id = 'test_connection_id'

      expect(client).to receive(:request).with(
        :get,
        "https://www.saltedge.com/api/v5/connections/#{connection_id}"
      )

      client.get_connection(connection_id)
    end
  end

  describe '#get_accounts' do
    it 'gets accounts for a connection' do
      connection_id = 'test_connection_id'

      expect(client).to receive(:request).with(
        :get,
        "https://www.saltedge.com/api/v5/accounts?connection_id=#{connection_id}"
      )

      client.get_accounts(connection_id)
    end
  end

  describe '#get_transactions' do
    it 'gets transactions for an account' do
      connection_id = 'test_connection_id'
      account_id = 'test_account_id'

      expect(client).to receive(:request).with(
        :get,
        "https://www.saltedge.com/api/v5/transactions?connection_id=#{connection_id}&account_id=#{account_id}"
      )

      client.get_transactions(connection_id, account_id)
    end
  end

  describe '#refresh_connection' do
    it 'refreshes a connection' do
      connection_id = 'test_connection_id'

      expect(client).to receive(:request).with(
        :put,
        "https://www.saltedge.com/api/v5/connections/#{connection_id}/refresh",
        payload: {
          data: {
            attempt: {
              fetch_scopes: %w[accounts transactions]
            }
          }
        }
      )

      client.refresh_connection(connection_id)
    end
  end

  describe '#delete_connection' do
    it 'deletes a connection' do
      connection_id = 'test_connection_id'

      expect(client).to receive(:request).with(
        :delete,
        "https://www.saltedge.com/api/v5/connections/#{connection_id}"
      )

      client.delete_connection(connection_id)
    end
  end

  describe '#reconnect_connection' do
    it 'reconnects a connection' do
      connection_id = 'test_connection_id'

      expect(client).to receive(:request).with(
        :post,
        'https://www.saltedge.com/api/v5/connect_sessions/reconnect',
        payload: {
          data: {
            connection_id:,
            consent: {
              from_date: '2020-05-08',
              period_days: 90,
              scopes: %w[account_details transactions_details]
            }
          }
        }
      )

      client.reconnect_connection(connection_id)
    end
  end
end
