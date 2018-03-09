class AddFlagsToTable < ActiveRecord::Migration[5.1]
 def up
   add_column :credit_lines, :enable, :boolean
   add_column :payment_cycles, :paid, :boolean
   add_column :transactions, :type, :integer
 end

 def down
   remove_column :credit_lines, :enable, :integer
   remove_column :payment_cycles, :paid,  :boolean
   remove_column :transactions, :type, :integer
 end
end
