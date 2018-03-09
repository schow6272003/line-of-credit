class User < ApplicationRecord
  has_many :credit_lines, dependent: :destroy
   validates :email, presence: true
end
