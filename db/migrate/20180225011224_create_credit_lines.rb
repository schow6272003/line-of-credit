class CreateCreditLines < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_lines do |t|
      t.belongs_to :user, index: true
      t.string :description
      t.decimal :limit, precision: 12, scale: 2
      t.decimal :balance, precision: 12, scale: 2
      t.float  :interest
      t.integer :number_of_days
      t.datetime :currnet_close_date
      t.timestamps  
    end
  end
end
