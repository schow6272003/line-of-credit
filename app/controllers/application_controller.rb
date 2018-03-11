class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session



  protected
      def authenticate_request!
        if !payload 
          return invalid_authentication
        end

        @current_user = User.find_by(id: payload['user_id'])
        invalid_authentication unless @current_user
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
