module CreditLineHelper
  require "date"
  DEFAULT_CREDIT_LINE = 1000
  DEFAULT_APR = 0.35
  DEFAULT_NUM_OF_DAYS = 30


  def check_payment_due_day(credit_line)
      return false if credit_line.payment_cycles.blank?
      close_date =  credit_line.payment_cycles.last.close_date 
     if (Time.now >= close_date) && credit_line.payment_cycles.last.paid.nil?
        credit_line.payment_cycles.last.paid = false 
        credit_line.payment_cycles.last.save
     end  
  end 
end