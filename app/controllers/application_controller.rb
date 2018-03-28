class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include SessionsHelper

  protected
    def authenticate_user!
       jtw_token = JsonWebToken.decode(session[:user_id]) 
       user_id = jtw_token["user_id"] unless jtw_token.blank?
       @current_user ||= User.find_by(id: user_id)
       redirect_to root_path if @current_user.blank?
    end 

    def authenticate_request!
      if !payload 
        return invalid_authentication
      end

      @current_user = User.find_by(id: payload['user_id']) 
      invalid_authentication if @current_user.blank?
    end

    def invalid_authentication
      render json: {error: 'Invalid Request'}, status: :unauthorized
    end

  private
    def payload
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JsonWebToken.decode(token)
    rescue
      nil
    end
end
