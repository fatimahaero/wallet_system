class Transaction < ApplicationRecord
  belongs_to :source_wallet, polymorphic: true, optional: true
  belongs_to :target_wallet, polymorphic: true, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_wallets

  after_create :update_wallet_balances

  private

  def validate_wallets
    if transaction_type == 'credit'
      errors.add(:source_wallet, "must be nil for credits") if source_wallet.present?
    elsif transaction_type == 'debit'
      errors.add(:target_wallet, "must be nil for debits") if target_wallet.present?
    else
      errors.add(:base, "Invalid transaction type")
    end
  end

  def update_wallet_balances
    # Source and Target wallet balance updates happen here
    Wallet.transaction do
      source_wallet.update!(balance: source_wallet.balance - amount) if source_wallet
      target_wallet.update!(balance: target_wallet.balance + amount) if target_wallet
    end
  end
end
