module Api
  module V1
      class PaymentCyclesController  < ApplicationController
        require "date"
        before_action :authenticate_request!
        
        def update
          payment_cycle = PaymentCycle.find(params[:id])
          transaction = payment_cycle.credit_line.transactions.new(option: "pay_off", amount: payment_cycle.outstanding_amount.to_f  + payment_cycle.accrued_interest.to_f + payment_cycle.past_due_amount.to_f, remaining_balance: payment_cycle.credit_line.limit )
          if transaction.save
             payment_cycle.paid = true
             payment_cycle.pay_off_transaction_id = transaction.id
             payment_cycle.save

            render json: {"payment_cycle" => payment_cycle,"transaction" => transaction}, status: 201
          else
            render json: transaction.errors, status: :unprocessable_entit
          end 
        end 
     end
  end
end