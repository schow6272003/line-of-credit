class Transaction < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :credit_line
  validates :amount, presence: true 
  enum  option: [:withdraw, :deposit, :pay_off] 

  before_create :set_outstanding_balance_on_transaction
  after_create :update_credit_line_balance
  after_create :set_payment_cycle, if: :is_not_pay_off_amount?
  after_create :set_payoff_amount, if: :is_not_pay_off_amount?



  def self.getFromCycle(payment_cycle)
    payment_cycle.credit_line.transactions.where('created_at BETWEEN ? AND ?', payment_cycle.beginning_date, payment_cycle.close_date ).where.not(option: "pay_off")
  end 

  private
    def set_outstanding_balance_on_transaction
      if self.option == "withdraw"
        self.remaining_balance  =  current_credit_line.balance - self.amount
      elsif self.option  == "deposit"
        self.remaining_balance  =  current_credit_line.balance + self.amount
      elsif self.option  == "pay_off"
        self.remaining_balance = current_credit_line.limit
        self.interest = nil
      end
    end

    def update_credit_line_balance
      if self.option == "withdraw"
        current_credit_line.balance -=  self.amount 
      elsif self.option  == "deposit"
        current_credit_line.balance += self.amount
      elsif self.option  == "pay_off"    

        current_credit_line.balance = current_credit_line.limit
      end

      current_credit_line.skip_limit_number_of_days_validation = true 
      current_credit_line.skip_balance_validation = true
      current_credit_line.save
    end  ## end of update_credit_balance

    def set_payment_cycle 
        number_of_days  = current_credit_line.number_of_days
        if current_credit_line.payment_cycles.blank?
           create_new_payment_cycle
        else 
          create_new_payment_cycle if current_payment_cylcle.close_date < self.created_at 
        end 
    end  ## end of set_payment_cycle function 


    def set_payoff_amount

       # transactions = current_credit_line.transactions.where('created_at BETWEEN ? AND ?', PaymentCycle.last.beginning_date, PaymentCycle.last.close_date ).where.not(option: "pay_off")
       transactions = Transaction.getFromCycle(current_payment_cycle)
       if transactions.size == 1 
           self.interest =  (current_credit_line.limit - current_credit_line.balance) * current_credit_line.interest / 365 * current_credit_line.number_of_days
           self.save
       elsif transactions.size > 1   
          prev_numbers_of_days  = (transactions[-2].created_at.to_date..transactions.last.created_at.to_date).count - 1
          next_numbers_of_days =  (transactions.last.created_at.to_date..current_payment_cycle.close_date.to_date).count - 1
          transactions.last.interest =  (current_credit_line.limit - transactions.last.remaining_balance) * current_credit_line.interest / 365 * next_numbers_of_days
          transactions[-2].interest =  (current_credit_line.limit - transactions[-2].remaining_balance) * current_credit_line.interest / 365 * prev_numbers_of_days
          transactions.last.save
          transactions[-2].save
       end 

       total_interest = transactions.inject(0){|sum, t| sum += t.interest }
       current_credit_line.payment_cycles.last.amount = total_interest  + (current_credit_line.limit - current_credit_line.balance)

       current_credit_line.payment_cycles.last.save
    end  ## end of set_payoff_amount function



    def current_credit_line
      self.credit_line
    end 

    def current_payment_cycle
      current_credit_line.payment_cycles.last
    end
    def create_new_payment_cycle
       begin_date = self.created_at
       close_date = begin_date + current_credit_line.number_of_days.days
       current_credit_line.payment_cycles.create(beginning_date:begin_date.to_date, close_date: close_date.to_date)
    end  ## end of create_new_payment_cycle


    def interest_amount(days)
      current_credit_line.balance * current_credit_line.interest / 365 * days
    end 

    def is_not_pay_off_amount?
      !(self.option == "pay_off")
    end
end
