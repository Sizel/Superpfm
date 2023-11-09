class AddNotNullConstraintToCustomerId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :customer_id, false
  end
end
