class FixOutstandingBallanceToTransaction < ActiveRecord::Migration[5.1]
  def up
    rename_column :transactions, :outstanding_balance, :remaining_balance
  end

  def down
    rename_column :transactions, :remaining_balance, :outstanding_balance
  end
end
