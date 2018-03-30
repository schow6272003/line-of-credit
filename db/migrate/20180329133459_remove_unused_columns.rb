class RemoveUnusedColumns < ActiveRecord::Migration[5.1]
  def up
    remove_column :credit_lines, :currnet_close_date
    remove_column :credit_lines, :enable
    remove_column :payment_cycles, :amount, :decimal, precision: 12, scale: 2
    remove_column :transactions, :interest
  end

  def down
    add_column :credit_lines, :currnet_close_date, :datetime
    add_column :credit_lines, :enable, :boolean
    add_column :payment_cycles, :amount, :decimal, precision: 12, scale: 2
    add_column :transactions, :interest, :float
  end 
end
