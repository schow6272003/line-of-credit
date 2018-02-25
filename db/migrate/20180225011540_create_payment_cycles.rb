class CreatePaymentCycles < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_cycles do |t|
      t.belongs_to :credit_line, index: true
      t.datetime :beginning_date
      t.datetime :close_date
      t.decimal :amount, precision: 12, scale: 2
      t.timestamps
    end
  end
end
