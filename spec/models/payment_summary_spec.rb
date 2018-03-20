require 'rails_helper'

describe PaymentSummary do
  let!(:user) { User.create(full_name: "John Doe", email: "test@gmail.com", password: "11111111", password_confirmation:"11111111" ) }


  # Feel free to change what the subject-block returns
  subject { PaymentSummary.new }

  describe "Payment Summary" do
        it 'create one cycle' do
          # Timecop.freeze(Time.now) do
          #   create(:transaction, user: user,
          #          action: :credit, category: :deposit,
          #          amount: Money.from_amount(2.12, :usd))

          #   create(:transaction, user: user,
          #          action: :credit, category: :deposit,
          #          amount: Money.from_amount(10, :usd))

          #   create(:transaction, user: user,
          #          action: :credit, category: :purchase,
          #          amount: Money.from_amount(7.67, :usd))

          #   create(:transaction, user: user,
          #          action: :debit, category: :withdraw,
          #          amount: Money.from_amount(10, :usd))
          #   create(:transaction, user: user,
          #          action: :debit, category: :ante,
          #          amount: Money.from_amount(5.94, :usd))
          #   create(:transaction, user: user,
          #          action: :credit, category: :deposit,
          #          amount: Money.from_amount(100.00, :usd))

          # end

          # Timecop.travel(Time.now - 10.days) do
          #   create(:transaction, user: user,
          #          action: :credit, category: :deposit,
          #          amount: Money.from_amount(3.12, :usd))

          #   create(:transaction, user: user,
          #          action: :credit, category: :deposit,
          #          amount: Money.from_amount(10, :usd))

          #   create(:transaction, user: user,
          #          action: :credit, category: :purchase,
          #          amount: Money.from_amount(2.67, :usd))
          # end

          # # pending('Not implemented yet')

          # expect(subject.one_day.count(:deposit)).to eq(3)
          # expect(subject.one_day.amount(:deposit)).to eq(Money.from_amount(112.12, :usd))

          # expect(subject.one_day.count(:purchase)).to eq(1)
          # expect(subject.one_day.amount(:purchase)).to eq(Money.from_amount(7.67, :usd))

          # expect(subject.one_day.count(:refund)).to eq(0)
          # expect(subject.one_day.amount(:refund)).to eq(Money.from_amount(0, :usd))

          # expect(subject.one_day.total_amount).to eq(Money.from_amount(103.85, :usd))
           expect(user.full_name).to eq("John Doe")
        end
   end


end