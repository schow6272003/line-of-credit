class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :credit_line, index: true
      t.decimal :amount, precision: 12, scale: 2
      t.timestamps
    end
  end
end
