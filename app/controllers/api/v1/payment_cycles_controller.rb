module Api
  module V1
      class PaymentCyclesController  < ApplicationController
        require "date"

        before_action :authenticate_request!
        
        def update
            payment_cycle = PaymentCycle.find(params[:id])
            payment_cycle.paid = true
            if payment_cycle.save
              transaction = payment_cycle.credit_line.transactions.create(option: "pay_off", amount: payment_cycle.amount, remaining_balance: payment_cycle.credit_line.limit )
              if transaction.valid?
                render json: {"transaction" => transaction}, status: 201
              else
                render json: transaction.errors, status: :unprocessable_entit
              end 
            else
              render json: payment_cycle.errors, status: :unprocessable_entit
            end 
        end 

     end
  end
end