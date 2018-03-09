class ChangeColumnsType < ActiveRecord::Migration[5.1]
  def up
    change_column :credit_lines, :balance, :decimal
    change_column :credit_lines, :limit, :decimal
    change_column :payment_cycles, :amount, :decimal
    change_column :transactions, :amount, :decimal
    change_column :transactions, :interest, :float
    change_column :transactions, :remaining_balance, :decimal
  end

  def down
  end
end
