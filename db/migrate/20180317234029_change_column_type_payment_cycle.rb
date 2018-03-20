class ChangeColumnTypePaymentCycle < ActiveRecord::Migration[5.1]
  def change
    change_column :payment_cycles, :accrued_interest, :float
  end

end
