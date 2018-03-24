require 'rails_helper'

describe CreditLine do
  let :user do
    User.create(email: 'test@gmail.com', full_name: "John Doe", password: "123456", password_confirmation: "123456")
  end

  let(:credit_line) {
     user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
  }


  context "Validity" do
    it 'is invalid without required attributes' do
     expect(CreditLine.new(limit: nil)).to be_invalid
     expect(CreditLine.new(interest: nil)).to be_invalid
     expect(CreditLine.new(number_of_days: nil)).to be_invalid
    end

    it "is invalid when balance is greater than limit amount" do 
      credit_line = CreditLine.new(user_id: user.id, limit: 1000, balance: 2000, interest: 0.35, number_of_days: 30)
      expect(credit_line).to be_invalid
    end


    it "is valid with required attributes" do
      expect(credit_line).to be_valid
    end 

    it "has empty payment_cycles by default" do
      expect(credit_line.payment_cycles).to eq([])
    end

    it "has empty transaction by default" do
      expect(credit_line.transactions).to eq([])
    end
  end 

  context "Transaction" do
     it "adjusts balance to be equal to last transaction's remaining_balance" do
      transaction = credit_line.transactions.create(option: :withdraw, amount: 300)
      expect(credit_line.balance).to eq(transaction.remaining_balance)
      expect(credit_line.payment_cycles.size).to eq(1)
     end
  end 


end