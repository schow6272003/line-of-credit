require 'rails_helper'
require 'date'
include ActionView::Helpers::NumberHelper
describe PaymentSummary do
  let!(:user) { User.create(full_name: "John Doe", email: "test@gmail.com", password: "11111111", password_confirmation:"11111111" ) }
  let!(:user2) { User.create(full_name: "Kevin Doe", email: "test2@gmail.com", password: "11111111", password_confirmation:"11111111" ) }

  let(:credit_line) { 
    CreditLine.create(user_id: user.id, limit: 1000, balance: 1000, number_of_days: 30, interest: 35, description: "Credit Line")
  }
  subject { PaymentSummary.new }


  it "creates user" do
    expect(user.email).to eq("test@gmail.com")
  end 

  it "creates credit line" do
     expect(credit_line).to be_valid
     expect(credit_line.user_id).not_to eq(2)
  end 


  it "create transaction" do 
    Timecop.freeze(Time.now) do 
      Transaction.create(credit_line: credit_line, 
             option: :withdraw, amount: 500)
    end 

    Timecop.travel(Time.now + 15.days) do 
     Transaction.create(credit_line: credit_line, 
             option: :deposit, amount: 200)
    end 

    Timecop.travel(Time.now + 25.days) do 
     Transaction.create(credit_line: credit_line, 
             option: :withdraw, amount: 100)
    end 

    subject.process
    updated_last_payment_cycle = PaymentCycle.where(credit_line_id: credit_line.id);

    expect(credit_line.transactions.count).to eq(3)
    expect(credit_line.transactions.last.remaining_balance).to eq(600.00)
    expect(credit_line.balance).to eq(600.00)
    expect(credit_line.payment_cycles.count).to eq(1)
    expect(credit_line.payment_cycles.last.beginning_date).to eq(credit_line.payment_cycles.last.next_beginning_date)
    expect(credit_line.payment_cycles.last.close_date).to eq(credit_line.payment_cycles.last.next_close_date)
    expect(credit_line.payment_cycles.last.beginning_date).to eq(credit_line.transactions.first.created_at.to_date)
    expect(number_to_currency(updated_last_payment_cycle.last.outstanding_amount.to_f, precision: 2)).to eq("$400.00")
    expect(number_to_currency(updated_last_payment_cycle.last.accrued_interest.to_f, precision: 2)).to eq("$11.99")
  end 

  it "create two payment cycles" do 

    Timecop.freeze(Time.now.to_date) do 
      credit_line.transactions.create(option: :withdraw, amount: 500)
    end 

    Timecop.travel(Time.now.to_date + 18.days) do 
      credit_line.transactions.create(option: :deposit, amount: 500)
    end 

    Timecop.travel(Time.now.to_date + 20.days) do 
      credit_line.transactions.create(option: :withdraw, amount: 100)
    end 

    Timecop.travel(Time.now.to_date + 31.days) do 
       subject.process
    end 


    Timecop.travel(Time.now.to_date + 34.days) do         
      subject.process
    end 

    Timecop.travel(Time.now.to_date + 35.days) do 
      credit_line.transactions.create(option: :withdraw, amount: 50)
    end 

    Timecop.travel(Time.now.to_date + 42.days) do 
      credit_line.transactions.create(option: :withdraw, amount: 30)
    end 


    Timecop.travel(Time.now.to_date + 59.days) do         
      subject.process
    end 

    Timecop.travel(Time.now.to_date + 61.days) do         
      subject.process
    end 

     payment_cycles = PaymentCycle.where(credit_line_id: credit_line.id)

     expect(payment_cycles.first.paid).to be false
     expect(number_to_currency(payment_cycles.first.outstanding_amount, precision: 2)).to eq("$100.00")
     expect(number_to_currency(payment_cycles.first.accrued_interest, precision: 2)).to eq("$9.59")
     expect(number_to_currency(payment_cycles.last.past_due_amount, precision: 2)).to eq("$109.59")
     expect(number_to_currency(payment_cycles.last.outstanding_amount, precision: 2)).to eq("$180.00")
     expect(number_to_currency(payment_cycles.last.accrued_interest, precision: 2)).to eq("$4.59")
     expect(PaymentCycle.count).to eq(2)
  end 


  it "process paid due payment " do
    Timecop.freeze(Time.now.to_date) do 
      credit_line.transactions.create(option: :withdraw, amount: 500)
    end 

    Timecop.freeze(Time.now.to_date + 31.days) do 
      subject.process
    end 

    Timecop.freeze(Time.now.to_date + 45.days) do 
      credit_line.payment_cycles.last.paid = true
      credit_line.payment_cycles.last.save
    end 

    Timecop.freeze(Time.now.to_date + 61.days) do 
      subject.process
    end 

    payment_cycles = PaymentCycle.where(credit_line_id: credit_line.id)
    accrued_interest = 500 * 0.35 / 365 * 30

    expect(payment_cycles.size).to eq(1)
    expect(payment_cycles.last.paid).to be true
    expect(payment_cycles.last.past_due_amount).to be_nil
    expect(payment_cycles.last.due_date).to eq(payment_cycles.last.close_date + 15.days)
    expect(payment_cycles.last.outstanding_amount).to eq(500)
    expect(payment_cycles.last.accrued_interest).to eq(accrued_interest)
  end 


  it "process paid due payment but made purchase after ward" do
    Timecop.freeze(Time.now.to_date) do 
      credit_line.transactions.create(option: :withdraw, amount: 300)
    end 

    Timecop.freeze(Time.now.to_date + 31.days) do 
      subject.process
    end 

    Timecop.freeze(Time.now.to_date + 45.days) do 
      credit_line.transactions.create(amount: 308.63, option: :pay_off)
      credit_line.payment_cycles.last.paid = true
      credit_line.payment_cycles.last.save
    end 

    Timecop.freeze(Time.now.to_date + 50.days) do 
      credit_line.transactions.create(option: :withdraw, amount: 200)
      credit_line.payment_cycles.last.save
    end 


    Timecop.freeze(Time.now.to_date + 61.days) do 
      subject.process
    end 

    payment_cycles = PaymentCycle.where(credit_line_id: credit_line.id)
    accrued_interest = 300 * 0.35 / 365 * 30
    accrued_interest_second_cycle = 200 * 0.35 / 365 * 10

    expect(payment_cycles.size).to eq(2)
    expect(payment_cycles.first.paid).to be true
    expect(payment_cycles.first.past_due_amount).to be_nil
    expect(payment_cycles.first.due_date).to eq(payment_cycles.first.close_date + 15.days)
    expect(payment_cycles.first.outstanding_amount).to eq(300)
    expect(payment_cycles.first.accrued_interest).to eq(accrued_interest)
    expect(payment_cycles.last.paid).to be false
    expect(payment_cycles.last.past_due_amount).to be_nil
    expect(payment_cycles.last.due_date).to eq(payment_cycles.last.close_date + 15.days)
    expect(payment_cycles.last.outstanding_amount).to eq(200)
    expect(payment_cycles.last.accrued_interest).to eq(accrued_interest_second_cycle)
    expect(payment_cycles.last.next_beginning_date).to eq(payment_cycles.last.close_date + 1.days)
    expect(payment_cycles.last.next_close_date).to eq(payment_cycles.last.close_date + 30.days)
  end
end