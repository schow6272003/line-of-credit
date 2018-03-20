class RenameNextCloseDateOnPaymentCycle < ActiveRecord::Migration[5.1]
  def change
   rename_column :payment_cycles, :next_end_date, :next_close_date
  end
end
