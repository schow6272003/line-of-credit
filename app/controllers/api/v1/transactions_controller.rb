module Api
  module V1
      class TransactionsController  < ApplicationController

        before_action :set_user

        # def show
        #   @credit_line = CreditLine.includes(:payment_cycles, :transactions).find(params[:id])

        #   if @credit_line
        #      render json: { "status" => 200, "credit_line" => @credit_line}
        #   else 
        #     render json: @credit_line.errors, status: :unprocessable_entit
        #   end

        # end 

        def create
          @transaction = Transaction.new(transaction_params)

          p "----- create transaction ------"
          p transaction_params

          if @transaction.save
            render json: { "status" => 201, "transaction" => @transaction}
          else
            render json: @transaction.errors, status: :unprocessable_entit
          end 
        end

        # def destroy 
        #    @credit_line = CreditLine.find(params[:id])

        #    if !@credit_line.blank? 
        #       @credit_line.destroy
        #       render json: { "status" => 200, "id" => @credit_line.id }
        #    else

        #      render json: { "status" => 400, "message" => "unable to delete credit line"}
        #    end
        # end


        private
         def set_user
           @user = User.find(params[:user_id])
         end

        def transaction_params
          params.permit(:credit_line_id, :option, :amount)
        end

      end
  end
end