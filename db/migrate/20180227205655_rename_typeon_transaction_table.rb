class RenameTypeonTransactionTable < ActiveRecord::Migration[5.1]
  def up
    rename_column :transactions, :type, :option
  end

  def down
     rename_column :transactions, :option, :type
  end
end
