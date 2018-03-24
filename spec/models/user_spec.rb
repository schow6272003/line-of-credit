require 'rails_helper'

describe User do

  subject {User.create(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")}
    

  context "Validity" do
    it "is invalid without email address" do
      user = User.new(email: nil)
      expect(user).to be_invalid
    end

    it "is invalid with wrong email address format" do
      user = User.new(email: "test2", password: "123456", password_confirmation: "123456")
      expect(user).to be_invalid
    end


    it "is invalid without password" do 
      user = User.new(password: nil)
      expect(user).to be_invalid
    end 

    it "is invalid if password length is at least 6" do 
      user = User.new(email: "test@gmail.com", password: "1234")
      expect(user).to be_invalid
    end 

    it "should validate unique email address" do 
       user  = User.create(full_name: "Jack Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")
       user2 = User.new(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")
       expect(user2).to be_invalid
    end 

    it "is valid with required attributes" do 
      expect(subject).to be_valid
    end 

  end 
end