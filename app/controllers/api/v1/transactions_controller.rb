module Api
  module V1
      class TransactionsController  < ApplicationController
        before_action :authenticate_request!

        def show
          @credit_line = CreditLine.includes(:payment_cycles, :transactions).find(params[:id])
          if @credit_line
             render json: { "credit_line" => @credit_line}, status: 200
          else 
            render json: @credit_line.errors, status: :unprocessable_entit
          end
        end 

        def create
          transaction = Transaction.new(transaction_params)
          if transaction.save
            render json: transaction, status: 201
          else
            render json: transaction.errors, status: :unprocessable_entit
          end 
        end

        private
          def transaction_params
            params.permit(:credit_line_id, :option, :amount)
          end

      end
  end
end