class ApplicationController < ActionController::API
  def authenticate_user!
    render json: { error: "Not Authorized" }, status: 401 unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
