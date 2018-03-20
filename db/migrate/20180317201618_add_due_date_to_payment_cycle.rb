class AddDueDateToPaymentCycle < ActiveRecord::Migration[5.1]
  def up
    add_column :payment_cycles, :due_date,  :datetime
  end

  def down
    remove_column :payment_cycles, :due_date,  :datetime
  end 
end
