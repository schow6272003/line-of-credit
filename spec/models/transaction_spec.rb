require 'rails_helper'
include ActionView::Helpers::NumberHelper
describe Transaction do
  let :user do
    User.create(email: 'test@gmail.com', password: "123456", password_confirmation: "123456" )
  end

  let(:credit_line) {
     user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
  }

  context "validity" do
    it "is invalid without required attributes" do 
      transaction = Transaction.new(credit_line_id: credit_line.id, option: :withdraw, amount: nil)
      expect(transaction).to be_invalid
    end 
    it "is valid with required attributes" do 
      transaction = Transaction.new(credit_line_id: credit_line.id, option: :withdraw, amount: 200)
      expect(transaction).to be_valid
    end 
  end 


end