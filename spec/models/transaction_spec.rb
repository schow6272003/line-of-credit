require 'rails_helper'
include ActionView::Helpers::NumberHelper
describe Transaction do
  let :user do
    User.create(email: 'test@gmail.com')
  end

  let(:credit_line) {
     user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
  }

  # let(:transaction) {
  #   transaction = credit_line.transactions.create(option: 0, amount: 200)
  # }

 

 #  it 'create transaction valid' do 
 #     expect(transaction).to be_valid
 # end


  # it 'expect to update credit line balance' do 
  #     expect(transaction.credit_line.balance).to eq(800.00)
  #     expect(transaction.remaining_balance).to eq(800.00)
  #     expect(transaction.credit_line.transactions.size).to eq(1)
  # end 


  # it 'expect to create payment cycle' do 
  #     expect(transaction.credit_line.payment_cycles.size).to eq(1)
  #     expect(transaction.credit_line.payment_cycles.last.beginning_date).to eq(transaction.created_at)
  #     expect(transaction.credit_line.payment_cycles.last.close_date).to eq(transaction.created_at + transaction.credit_line.number_of_days.days)
  # end 

  it 'calculate Scenario 1' do 
  # They draws $500 on day one so their remaining credit limit is $500 and their balance is $500. 
  # They keep the money drawn for 30 days. They should owe $500 * 0.35 / 365 * 30 = 14.38$ worth of interest on day 30. 
  #Total payoff amount would be $514.38
   Timecop.freeze(Time.now) do 
      credit_line.transactions.create(option: 0, amount: 500)
   end 
     
    expect(credit_line.transactions.size).to eq(1)
    expect(credit_line.payment_cycles.size).to eq(1)
    expect(credit_line.payment_cycles.last.amount).to eq(514.38)
    expect(credit_line.balance).to eq(500)
  end 


  it 'calculate scenario 2' do 
    #They draw $500 on day one so their remaining credit limit is $500 and their balance is $500. 
    #They pay back $200 on day 15 and then draws another 100$ on day 25. 
    #Their total owed interest on day 30 should be 500 * 0.35 / 365 * 15 + 300 * 0.35 / 365 * 10 + 400 * 0.35 / 365 * 5 which is 11.99. 
    #Total payment should be $411.99.

     Timecop.freeze(Time.now) do 
       credit_line.transactions.create(option: 0, amount: 500)
     end 
     
     Timecop.freeze(Time.now + 15.days) do
      credit_line.transactions.create(option: 1, amount: 200)
     end

     Timecop.freeze(Time.now + 25.days) do
      credit_line.transactions.create(option: 0, amount: 100)
     end


      expect(credit_line.transactions.size).to eq(3)
      expect(credit_line.payment_cycles.size).to eq(1)
      expect(credit_line.payment_cycles.last.amount).to eq(411.99)
      expect(credit_line.balance).to eq(600)
 end 


 it 'calculate payoff days for multiple cycles' do


 end

  # it 'can have [deposit, purchase, refund] category on credit action' do
  #   subject.action = :credit
  #   subject.category = :deposit
  #   expect(subject.valid?).to eq(true)

  #   subject.action = :credit
  #   subject.category = :withdraw
  #   expect(subject.valid?).to eq(false)

  #   subject.action = :credit
  #   subject.category = :refund
  #   expect(subject.valid?).to eq(true)

  #   subject.action = :credit
  #   subject.category = :purchase
  #   expect(subject.valid?).to eq(true)
  # end

  # it 'can have [withdraw, ante] category on debit action' do
  #   subject.action = :debit
  #   subject.category = :deposit
  #   expect(subject.valid?).to eq(false)

  #   subject.action = :debit
  #   subject.category = :withdraw
  #   expect(subject.valid?).to eq(true)

  #   subject.action = :debit
  #   subject.category = :ante
  #   expect(subject.valid?).to eq(true)
  # end

  # it 'must have greater than zero amount' do
  #   subject.amount = Money.from_amount(0, :usd)
  #   expect(subject.valid?).to eq(false)

  #   subject.amount = Money.from_amount(-1, :usd)
  #   expect(subject.valid?).to eq(false)

  #   subject.amount = Money.from_amount(0.01, :usd)
  #   expect(subject.valid?).to eq(true)
  # end
end