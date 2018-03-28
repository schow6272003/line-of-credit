class Transaction < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  belongs_to :credit_line
  validates :amount, presence: true 
  enum  option: [:withdraw, :deposit, :pay_off] 

  before_create :set_outstanding_balance_on_transaction
  after_create :update_credit_line_balance
  after_create :create_new_payment_cycle, if: :are_payment_cycles_blank?

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
    end

    def current_credit_line
      self.credit_line
    end 

    def create_new_payment_cycle
       begin_date = self.created_at.to_date
       close_date = begin_date + 29.days
       current_credit_line.payment_cycles.create(beginning_date:begin_date, close_date: close_date, next_beginning_date: begin_date, next_close_date:close_date, paid: nil )
    end 

    def are_payment_cycles_blank?
      current_credit_line.payment_cycles.blank?
    end
end
