class RemoveStatusFromAccounts < ActiveRecord::Migration[7.1]
  def change
    remove_column :accounts, :status
  end
end
