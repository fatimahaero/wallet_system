class ChangeColumnNameToNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :transactions, :source_wallet_id, true
    change_column_null :transactions, :source_wallet_type, true
    change_column_null :transactions, :target_wallet_id, true
    change_column_null :transactions, :target_wallet_type, true
  end
end
