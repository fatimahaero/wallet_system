class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true	
  has_one :wallet, as: :owner, dependent: :destroy

  after_create :create_wallet

  private

  def create_wallet
    Wallet.create(owner: self, balance: 0)
  end
end
