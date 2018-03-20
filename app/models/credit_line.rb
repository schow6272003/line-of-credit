class CreditLine < ApplicationRecord
  include CreditLineHelper
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :payment_cycles, dependent: :destroy


  validates :limit, :interest, :number_of_days, presence: true,  unless: :skip_limit_number_of_days_validation
  validates :balance, numericality: { less_than_or_equal_to: :limit },  unless: :skip_balance_validation
  
  #Assign default values at initialization of record
  before_create :initialize_default_values

  attr_accessor :skip_limit_number_of_days_validation, :skip_balance_validation

  def self.with_transactions
    includes(:transactions).where.not(:transactions=> { :id => nil })
  end 

 
 private

  def initialize_default_values
    self.interest = !self.interest.blank? ? self.interest*0.01 : CreditLineHelper::DEFAULT_APR
    self.limit =  self.limit || CreditLineHelper::DEFAULT_CREDIT_LINE
    self.balance = self.limit || CreditLineHelper::DEFAULT_CREDIT_LINE
    self.number_of_days = self.number_of_days || CreditLineHelper::DEFAULT_NUM_OF_DAYS
  end


end
