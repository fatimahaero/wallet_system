class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    source_wallet = Wallet.find_by(id: transaction_params[:source_wallet_id])
    target_wallet = Wallet.find_by(id: transaction_params[:target_wallet_id])
    amount = transaction_params[:amount].to_f

    if Wallet.transfer_funds(source_wallet: source_wallet, target_wallet: target_wallet, amount: amount, transaction_type: transaction_params[:transaction_type])
      render json: { status: 'success', message: 'Funds transferred successfully' }, status: :ok
    else
      render json: { status: 'error', message: 'Transfer failed' }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:source_wallet_id, :target_wallet_id, :amount, :transaction_type)
  end
end

