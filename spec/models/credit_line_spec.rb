# require 'rails_helper'

# describe CreditLine do
#   let :user do
#     User.create(email: 'test@gmail.com')
#   end

#   let(:credit_line) {
#      user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
#   }


#   it 'credit line should be valid' do
#    expect(credit_line).to be_valid
#   end



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
#   # end
# end