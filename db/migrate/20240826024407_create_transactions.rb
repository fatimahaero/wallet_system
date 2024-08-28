class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 15, scale: 2
      t.references :source_wallet, polymorphic: true, null: false
      t.references :target_wallet, polymorphic: true, null: false
      t.string :transaction_type

      t.timestamps
    end
  end
end
