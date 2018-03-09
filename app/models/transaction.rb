class Transaction < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :credit_line
  validates :amount, presence: true 
  enum  option: [:withdraw, :deposit, :pay_off] 

  before_create :set_outstanding_balance_on_transaction
  after_create :update_credit_line_balance
  after_create :set_payment_cycle, if: :is_not_pay_off_amount?
  after_create :set_payoff_amount, if: :is_not_pay_off_amount?


  private
    def set_outstanding_balance_on_transaction
      if self.option == "withdraw"
        self.remaining_balance  =  self.credit_line.balance - self.amount
      elsif self.option  == "deposit"
        self.remaining_balance  =  self.credit_line.balance + self.amount
      elsif self.option  == "pay_off"
        self.remaining_balance = self.credit_line.limit
        self.interest = nil
      end
    end

    def update_credit_line_balance
      if self.option == "withdraw"
        self.credit_line.balance -=  self.amount 
      elsif self.option  == "deposit"
        self.credit_line.balance += self.amount
      elsif self.option  == "pay_off"    

        self.credit_line.balance = self.credit_line.limit
      end

      self.credit_line.skip_limit_number_of_days_validation = true 
      self.credit_line.skip_balance_validation = true
      self.credit_line.save
    end  ## end of update_credit_balance

    def set_payment_cycle 
        number_of_days  = self.credit_line.number_of_days
        if self.credit_line.payment_cycles.blank?
           create_new_payment_cycle
        else 
           current_payment_cylcle  = self.credit_line.payment_cycles.last
           current_close_date = current_payment_cylcle.close_date

           if current_close_date < self.created_at 
            create_new_payment_cycle
           end 
        end 
    end  ## end of set_payment_cycle function 


    def set_payoff_amount
       transactions = self.credit_line.transactions.where('created_at BETWEEN ? AND ?', PaymentCycle.last.beginning_date, PaymentCycle.last.close_date ).where.not(option: "pay_off")
       if transactions.size == 1 
           self.interest =  (self.credit_line.limit - self.credit_line.balance) * self.credit_line.interest / 365 * self.credit_line.number_of_days
           self.save
       elsif transactions.size > 1   
          prev_numbers_of_days  = (transactions[-2].created_at.to_date..transactions.last.created_at.to_date).count - 1
          next_numbers_of_days =  (transactions.last.created_at.to_date..PaymentCycle.last.close_date.to_date).count - 1
          transactions.last.interest =  (self.credit_line.limit - transactions.last.remaining_balance) * self.credit_line.interest / 365 * next_numbers_of_days
          transactions[-2].interest =  (self.credit_line.limit - transactions[-2].remaining_balance) * self.credit_line.interest / 365 * prev_numbers_of_days
          transactions.last.save
          transactions[-2].save
       end 

   
       total_interest = transactions.inject(0){|sum, t| sum += t.interest }
       self.credit_line.payment_cycles.last.amount = total_interest  + (self.credit_line.limit - self.credit_line.balance)

       self.credit_line.payment_cycles.last.save
    end  ## end of set_payoff_amount function

    def create_new_payment_cycle
       begin_date = self.created_at
       close_date = begin_date + self.credit_line.number_of_days.days
       self.credit_line.payment_cycles.create(beginning_date:begin_date.to_date, close_date: close_date.to_date)
    end  ## end of create_new_payment_cycle


    def interest_amount(days)
      self.credit_line.balance * self.credit_line.interest / 365 * days
    end 

    def is_not_pay_off_amount?
      !(self.option == "pay_off")
    end
end
