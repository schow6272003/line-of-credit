module Api
  module V1
      class CreditLinesController  < ApplicationController
        require "date"

        before_action :set_user
        def index
          render json: @user.credit_lines
        end

        def show
          @credit_line = CreditLine.includes(:payment_cycles, :transactions).find(params[:id])
          if @credit_line

             current_date = Time.now
             render json: { "status" => 200, "credit_line" => @credit_line, "payment_cycle" => @credit_line.payment_cycles.last, "transactions" => @credit_line.transactions}
          else 
            render json: @credit_line.errors, status: :unprocessable_entit
          end

        end 

        def create
          @credit_line =  CreditLine.new(credit_line_params)

          p "-----"
          p params

          if @credit_line.save
            render json: { "status" => 201, "credit_line" => @credit_line}
          else
            render json: @credit_line.errors, status: :unprocessable_entit
          end 
        end

        def destroy 
           @credit_line = CreditLine.find(params[:id])

           if !@credit_line.blank? 
              @credit_line.destroy
              render json: { "status" => 200, "id" => @credit_line.id }
           else

             render json: { "status" => 400, "message" => "unable to delete credit line"}
           end
        end


        private
         def set_user
           @user = User.find(params[:user_id])
         end

        def credit_line_params
          params.permit(:user_id, :description, :limit, :balance, :interest, :number_of_days)
        end

      end
  end
end