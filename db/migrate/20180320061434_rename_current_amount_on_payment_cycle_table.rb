class RenameCurrentAmountOnPaymentCycleTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :payment_cycles, :current_amount, :outstanding_amount
  end
end
