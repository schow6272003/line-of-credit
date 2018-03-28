module Api
  module V1
      class UsersController  < ApplicationController
       include SessionsHelper

       def check_email
         user = User.find_by_email(params[:email])
         render json: { "switch" => !user }, status: 200
       end 

       def check_existed_email
         user = User.find_by_email(params[:email])
         render json: { "switch" => !user.blank? }, status: 200
       end 


       def create
          user = User.new(user_params)
          if user.save
            user_id = JsonWebToken.encode({ user_id: user.id })
            login user_id
            render json:  { "token" => user_id}, status: 201
          else  
            render json: { errors: user.errors }, status: :unprocessable_entit
          end 
       end 
       
       def update
          user = User.find(params[:id])
          if user.update(user_params)
            render json: user, status: 200
          else
            render json: { errors: user.errors }, status: 422
          end
       end

       def destroy
          user = User.find(params[:id])
          user.destroy
          head 204
       end

       private
        def user_params
          params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
        end

      end
  end
end