class CreditLinesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    @credit_lines = @current_user.credit_lines 
  end
end