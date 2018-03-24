require 'rails_helper'

describe PaymentCycle do
  let :user do
    User.create(email: 'test@gmail.com', full_name: "John Doe", password: "123456", password_confirmation: "123456")
  end

  let(:credit_line) {
     user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
  }

  let(:transaction) {
     user.credit_line.transactions.create(option: :withdraw, amount: 200)
  }

  it "creates initial payment cycle on first transaction" do
    expect(credit_line.payment_cycles.size).to eq(1)
  end

end