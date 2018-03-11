module Api
  module V1
      class UsersController  < ApplicationController
        
       def create
        user = User.new(user_params)
        if user.save
          render json: user, status: 201
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

       def confirm
       end

       def login
       end




       private

        def user_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

      end
  end
end