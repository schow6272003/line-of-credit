class PaymentCycle < ApplicationRecord
  belongs_to :credit_line
  # validates :beginning_date, :close_date, presence: true 
end
