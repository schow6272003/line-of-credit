module Api
  module V1
      class CreditLinesController  < ApplicationController
        include CreditLineHelper
        require "date"
        before_action :authenticate_request!

        def index
          render json: @current_user.credit_lines
        end

        def show
          @credit_line = CreditLine.includes(:payment_cycles, :transactions).find(params[:id])
          if @credit_line
            render json: {"credit_line" => @credit_line, "payment_cycles" => @credit_line.payment_cycles, "transactions" => @credit_line.transactions}, status: 200
          else 
            render json: @credit_line.errors, status: :unprocessable_entit
          end
        end 

        def create
          credit_line = @current_user.credit_lines.build(credit_line_params)
          if credit_line.save
            render json: credit_line, status: 201
          else
            render json: credit_line.errors, status: :unprocessable_entit
          end 
        end

        def destroy 
          credit_line = CreditLine.find_by_id(params[:id])
          if !credit_line.blank? 
            credit_line.destroy
            render json: credit_line.id, status: 200
          else
            render json:  {error: 'Invalid Request'}, status: :unprocessable_entit
          end
        end

        private
         def credit_line_params
          params.permit(:description, :limit, :balance, :interest, :number_of_days)
         end
      end
  end
end