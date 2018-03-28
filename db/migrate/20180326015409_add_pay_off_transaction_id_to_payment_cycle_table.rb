class AddPayOffTransactionIdToPaymentCycleTable < ActiveRecord::Migration[5.1]
  def up
    add_column :payment_cycles, :pay_off_transaction_id, :integer
  end

  def down
    remove_column :payment_cycles, :pay_off_transaction_id, :integer
  end
end
