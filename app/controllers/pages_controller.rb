class PagesController < ApplicationController

   before_action :set_user

  def index

    @credit_lines = @user.credit_lines 

  end

  def create
  
  end 

  def update
  end

  def destroy
  end

  private
   def set_user
     @user = User.find(2)
   end

end