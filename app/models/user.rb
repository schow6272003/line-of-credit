class User < ApplicationRecord
  has_many :credit_lines, dependent: :destroy
  validates :password, length: { minimum: 6 }
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  has_secure_password
  before_save :down_case_email

  def down_case_email
     self.email = self.email.downcase
  end
 
end
  