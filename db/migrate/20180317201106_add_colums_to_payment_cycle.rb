class AddColumsToPaymentCycle < ActiveRecord::Migration[5.1]
  def up
    add_column :payment_cycles, :past_due_amount,  :decimal, precision: 12, scale: 2
    add_column :payment_cycles, :current_amount,  :decimal, precision: 12, scale: 2
    add_column :payment_cycles, :accrued_interest,  :float
  end

  def down
    remove_column :payment_cycles, :past_due_amount,  :decimal, precision: 12, scale: 2
    remove_column :payment_cycles, :current_amount,  :decimal, precision: 12, scale: 2
    remove_column :payment_cycles, :accrued_interest,  :float

  end 
end
