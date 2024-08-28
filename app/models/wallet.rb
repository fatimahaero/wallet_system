class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_many :transactions_as_source, class_name: 'Transaction', foreign_key: :source_wallet_id
  has_many :transactions_as_target, class_name: 'Transaction', foreign_key: :target_wallet_id

  # Transfer money between two wallets
  def self.transfer_funds(source_wallet:, target_wallet:, amount:, transaction_type:)
    # Use ActiveRecord transaction to ensure ACID compliance
    ActiveRecord::Base.transaction do
      if transaction_type == 'debit'
        # Debit the source wallet
        source_wallet.debit(amount)
      elsif transaction_type == 'credit'
        # Credit the target wallet
        target_wallet.credit(amount)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    # Handle the error, transaction is automatically rolled back
    Rails.logger.error("Transaction failed: #{e.message}")
    return false
  end

  # Debit method for a wallet
  def debit(amount)
    if self.balance < amount
      raise ActiveRecord::RecordInvalid, "Insufficient funds in the source wallet"
    end

    # Create a debit transaction
    transactions_as_source.create!(
      amount: amount,
      transaction_type: 'debit'
    )
  end

  # Credit method for a wallet
  def credit(amount)
    # Create a credit transaction
    transactions_as_target.create!(
      amount: amount,
      transaction_type: 'credit'
    )
  end

  # Calculate wallet balance
  def balance
    # Balance is total credits minus total debits
    transactions_as_target.sum(:amount) - transactions_as_source.sum(:amount)
  end
end
