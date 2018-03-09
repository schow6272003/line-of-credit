module Api
  module V1
      class PaymentCyclesController  < ApplicationController
        require "date"

        before_action :set_user
        def show
        end
        
        def update
            payment_cycle = PaymentCycle.find(params[:id])

            payment_cycle.paid = true

            if payment_cycle.save
              result = payment_cycle.credit_line.transactions.create(option: "pay_off", amount: payment_cycle.amount, remaining_balance: payment_cycle.credit_line.limit )
              
              if result.valid?
                render json: {"status" => 201, "payment_cycle" => payment_cycle }
              else
                render json: result.errors, status: :unprocessable_entit
              end 
            else
              render json: payment_cycle.errors, status: :unprocessable_entit
            end 
        end 

        private
         def set_user
           @user = User.find(params[:user_id])
         end
     end
  end
end