class UsersController < ApplicationController

  def balance
    user = User.find(params[:id])
    balance = user.wallet.balance

    render json: { user_id: user.id, balance: balance }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end
