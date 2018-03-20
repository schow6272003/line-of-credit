class AddNextPaymentDatesToPaymentCycle < ActiveRecord::Migration[5.1]
  def up
    add_column :payment_cycles, :next_beginning_date, :datetime
    add_column :payment_cycles, :next_end_date, :datetime
  end
  def down
    remove_column :payment_cycles, :next_beginning_date, :datetime
    remove_column :payment_cycles, :next_end_date, :datetime
  end 
end
