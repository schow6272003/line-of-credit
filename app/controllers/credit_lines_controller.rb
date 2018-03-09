class CreditLinesController < ApplicationController

  def index
    render json: CreditLine.all
  end

  def create
  end

  def update
  end

  def delete
  end
end