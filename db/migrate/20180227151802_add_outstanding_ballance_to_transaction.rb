class AddOutstandingBallanceToTransaction < ActiveRecord::Migration[5.1]
  def up
    add_column :transactions, :outstanding_balance, :decimal, precision: 12, scale: 2
  end

  def down
    remove_column :transactions, :outstanding_balance, :decimal, precision: 12, scale: 2
  end
end
