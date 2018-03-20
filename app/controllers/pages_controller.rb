class PagesController < ApplicationController
  def index
    paymentSummary = PaymentSummary.new 
    paymentSummary.calculate

  end


end