module Api
  module V1
      class SessionsController  < ApplicationController
        include SessionsHelper
        
        def create
          user = User.find_by(email: params[:session][:email])
          if user  &&  user.authenticate(params[:session][:password])
            user_id = JsonWebToken.encode({ user_id: user.id })
            login user_id
            render json: { user_id: user_id},  status: 201
          else 
           render json: {error: 'Invalid email/password combination'}, status: :unauthorized
          end 
        end

        def destroy
          log_out_session
          head 204
        end 
      end
  end
end