class PaymentSummary

   def initialize
     @credit_lines = credit_lines
   end

  def calculate

     @credit_lines.each do |credit_line|
      current_transaction = credit_line.transactions.last
      dates = get_current_payment_dates(credit_line)

        p "------ test"
        p credit_line.id
        p dates
        p "------ test"
        if credit_line.payment_cycles.blank? 
           create_payment_cycle(credit_line, dates["beginning_date"], dates["close_date"], dates["close_date"], dates["close_date"] + 30.days)
        else
         if (dates["beginning_date"] <= current_transaction.created_at.to_date) && (current_transaction.created_at.to_date <= dates["close_date"])
             ### calculate de
             p "---- inside"
            past_due_amount = credit_line.payment_cycles.last.current_amount.to_f +  credit_line.payment_cycles.last.accrued_interest.to_f

            create_payment_cycle(credit_line, dates["beginning_date"], dates["close_date"], dates["close_date"], dates["close_date"] + 30.days)

            if credit_line.payment_cycles.last.paid == false
              credit_line.payment_cycles.last.past_due_amount = credit_line.payment_cycles.last.past_due_amount.to_f + past_due_amount
              credit_line.payment_cycles.last.save
            end

         else 

         end 


        end
          

        

        #  create_payment_cycle(credit_line)
       

        # current_payment_cylcle = credit_line.payment_cycles.last

        # if current_payment_cylcle.close_date + 30.days < current_due_date
        #   transactions  = Transaction.getFromCycle(current_payment_cylcle) 

    end

  end

private

  def transactions_occcur_from_period?(dates, credit_line)
    credit_line.transactions.where('created_at BETWEEN ? AND ?', dates["beginning_date"], dates["end_date"]).where.not(option: "pay_off")
  end 
 
  def current_due_date 
    Date.today.at_beginning_of_month.next_month
  end

  def get_curent_close_date_for(credit_line) 
     credit_line.payment_cycles.last.close_date
  end 

  def get_current_payment_dates(credit_line)
    if credit_line.payment_cycles.blank?
      { "beginning_date" =>  credit_line.transactions.first.created_at.to_date, "close_date" =>  (credit_line.transactions.first.created_at.to_date + 30.days).to_date }
    else
      { "beginning_date" =>  credit_line.payment_cycles.last.next_beginning_date.to_date, "close_date" =>  credit_line.payment_cycles.last.next_close_date.to_date }
    end
  end 

  def create_payment_cycle(credit_line,  beginning_date, close_date, next_beginning_date, next_close_date) 
    credit_line.payment_cycles.create(beginning_date: beginning_date, close_date: close_date, next_beginning_date: next_beginning_date, next_close_date: next_close_date )
  end 
  
  def credit_lines
     CreditLine.with_transactions
  end 

end