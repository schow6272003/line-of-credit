class PagesController < ApplicationController
  def index
    paymentSummary = PaymentSummary.new 
    paymentSummary.process

  end


end