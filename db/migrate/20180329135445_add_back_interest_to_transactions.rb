class AddBackInterestToTransactions < ActiveRecord::Migration[5.1]
  def up
    add_column :transactions, :interest, :float
  end

  def down
    remove_column :transactions, :interest, :float
  end 
end
