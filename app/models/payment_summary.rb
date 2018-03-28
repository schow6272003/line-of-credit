class PaymentSummary

  def initialize
  end

  def process
    credit_lines.each do |credit_line|
        last_payment_cycle = credit_line.payment_cycles.last 
        current_date = Time.now.to_date
        current_close_date = current_date - 1.days
        if last_payment_cycle.close_date == last_payment_cycle.next_close_date
            calculate_payoff_amount(last_payment_cycle.beginning_date, last_payment_cycle.close_date, credit_line)
            last_payment_cycle.paid = false
            last_payment_cycle.due_date = last_payment_cycle.close_date + 15.days
            last_payment_cycle.next_beginning_date  = last_payment_cycle.close_date + 1.days
            last_payment_cycle.next_close_date  = last_payment_cycle.close_date + 30.days
            last_payment_cycle.save
        elsif  last_payment_cycle.next_close_date == current_close_date
              next_beginning_date = last_payment_cycle.next_close_date + 1.days
              next_close_date  = last_payment_cycle.next_close_date + 30.days
              due_date = last_payment_cycle.next_close_date + 15.days
            if last_payment_cycle.paid == false
              past_due_amount = last_payment_cycle.outstanding_amount + last_payment_cycle.accrued_interest + last_payment_cycle.past_due_amount.to_f
              credit_line.payment_cycles.create(beginning_date: last_payment_cycle.next_beginning_date, close_date: last_payment_cycle.next_close_date, paid: false, past_due_amount: past_due_amount, due_date: due_date, next_beginning_date: next_beginning_date, next_close_date: next_close_date )
              calculate_payoff_amount(last_payment_cycle.next_beginning_date, last_payment_cycle.next_close_date, credit_line)
            elsif last_payment_cycle.paid == true
               if !transactions_from_period(last_payment_cycle.next_beginning_date, last_payment_cycle.next_close_date, credit_line).blank?
                credit_line.payment_cycles.create(beginning_date: last_payment_cycle.next_beginning_date, close_date: last_payment_cycle.next_close_date, paid: false, due_date: due_date, next_beginning_date: next_beginning_date, next_close_date: next_close_date )
                calculate_payoff_amount(last_payment_cycle.next_beginning_date, last_payment_cycle.next_close_date, credit_line)
               else
                 last_payment_cycle.next_beginning_date  = last_payment_cycle.next_close_date + 1.days 
                 last_payment_cycle.next_close_date = last_payment_cycle.next_close_date + 30.days
                 last_payment_cycle.save
               end
            end
        end 
    end
  end

private

  def calculate_payoff_amount(beginning_date, close_date, credit_line)
      transactions = transactions_from_period(beginning_date, close_date, credit_line)
      total_interest = 0
      last_payment_cycle = credit_line.payment_cycles.last
      unless transactions.count == 0
        if beginning_date < transactions.first.created_at.to_date
           last_transaction = credit_line.transactions.where("id <  ? ", transactions.first.id ).last 
           last_transaction_remaining_balance = (last_Ptransaction) ? last_transaction.remaining_balance :  0
          days_at_this_balance = (beginning_date.to_date..transactions.first.created_at.to_date).count.to_i - 1
          total_interest += (credit_line.limit - last_transaction_remaining_balance) * credit_line.interest / 365 * days_at_this_balance
        end 

      end

      transactions.each_with_index do |t, i |
        if t != transactions.last
          days_at_this_balance = (t.created_at.to_date..transactions[i+1].created_at.to_date).count.to_i - 1
        else
          days_at_this_balance = (t.created_at.to_date..last_payment_cycle.close_date.to_date).count.to_i
        end 
        total_interest += (credit_line.limit - t.remaining_balance) * credit_line.interest / 365 * days_at_this_balance
      end 

      outstanding_balance = credit_line.limit - credit_line.balance
      last_payment_cycle.accrued_interest = total_interest
      last_payment_cycle.outstanding_amount = credit_line.limit - credit_line.balance
      last_payment_cycle.save
  end

  def transactions_from_period(beginning_date, close_date, credit_line)
    credit_line.transactions.where('created_at BETWEEN ? AND ?', beginning_date, close_date).where.not(option: "pay_off")
  end 

  def credit_lines
     CreditLine.with_transactions
  end 

end