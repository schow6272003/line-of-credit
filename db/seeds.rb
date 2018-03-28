# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first) 


# user = User.create(:email => "wenwoechow@gmail.com", :full_name => "Steven Chow")


# user.credit_lines.create(balance: 1000)



credit_line = CreditLine.find(34)
credit_line.balance = 2000
credit_line.save

first_date =  Date.new(2018,1,15).to_date
credit_line = CreditLine.find(34)
credit_line.balance = 2000
credit_line.save
transaction_date = first_date + 5.days
credit_line.transactions.create(created_at: first_date + 5.days, option: :withdraw, amount: 500 )
credit_line.transactions.create(created_at: transaction_date + 15.days, option: :deposit, amount: 200 )
credit_line.transactions.create(created_at: transaction_date + 25.days, option: :withdraw, amount: 100 )
