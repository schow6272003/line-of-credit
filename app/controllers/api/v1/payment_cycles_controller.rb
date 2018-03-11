module Api
  module V1
      class PaymentCyclesController  < ApplicationController
        require "date"

        before_action :authenticate_request!
        before_action :set_user
        
        def update
            payment_cycle = PaymentCycle.find(params[:id])
            payment_cycle.paid = true
            if payment_cycle.save
              result = payment_cycle.credit_line.transactions.create(option: "pay_off", amount: payment_cycle.amount, remaining_balance: payment_cycle.credit_line.limit )
              if result.valid?
                render json: {"payment_cycle" => payment_cycle }, status: 201
              else
                render json: result.errors, status: :unprocessable_entit
              end 
            else
              render json: payment_cycle.errors, status: :unprocessable_entit
            end 
        end 

     end
  end
end