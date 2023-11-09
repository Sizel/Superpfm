class ImportDataJob < ApplicationJob
  queue_as :default

  def perform(webhook_data)
    connection = create_or_update_connection(webhook_data)

    return if webhook_data["error_class"] == "InvalidCredentials"

    fetch_accounts(connection)
    fetch_transactions(connection)
  end

  private

  def fetch_transactions(connection)
    Account.where(connection_id: connection.id).each do |account|
      transactions = SaltedgeClient.new.get_transactions(connection.connection_id, account.account_id)["data"]
      create_or_update_transactions(transactions, account.id)
    end
  end

  def create_or_update_transactions(transactions, account_id)
    transactions.each do |transaction|
      transaction_record = Transaction.find_or_initialize_by(transaction_id: transaction["id"])
      transaction_record.update!(
        amount: transaction["amount"],
        currency_code: transaction["currency_code"],
        description: transaction["description"],
        made_on: transaction["made_on"],
        status: transaction["status"],
        account_id:
      )
    end
  end

  def fetch_accounts(connection)
    accounts = SaltedgeClient.new.get_accounts(connection.connection_id)["data"]

    accounts.each do |account|
      account_record = Account.find_or_initialize_by(account_id: account["id"])
      account_record.update!(
        balance: account["balance"],
        currency_code: account["currency_code"],
        name: account["name"],
        nature: account["nature"],
        connection_id: connection.id
      )
    end
  end

  def create_or_update_connection(webhook_data)
    connection_id = webhook_data["connection_id"]
    customer_id   = webhook_data["customer_id"]

    user = User.find_by(customer_id:)

    connection               = SaltedgeClient.new.get_connection(connection_id)["data"]
    provider_code            = connection["provider_code"]
    next_refresh_possible_at = connection["next_refresh_possible_at"]
    status                   = connection["status"]

    connection_record = Connection.find_or_initialize_by(connection_id:)
    connection_record.update!(provider_code:, next_refresh_possible_at:, status:, user_id: user.id)

    connection_record
  end
end
