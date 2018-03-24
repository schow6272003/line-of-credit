require 'rails_helper'
require 'jwt_token'
require 'bcrypt'
include SessionsHelper

describe Api::V1::UsersController, type: :request do 
    let(:user) {User.create(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")}
    let(:params) { { user: {full_name: "Kevin Doe", email: 'test2@gmail.com', password: "123456", password_confirmation: "123456"} }}
    let(:dublicate_params) { { user: {full_name:  "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456"}}}
    let(:update_params) { { user: {full_name:  "Joseph J. Law", password: "111111", password_confirmation: "111111"}} }
    let(:invalid_update_params) { { user: { email: 'test2@gmail.com', password: "111111", password_confirmation: "111111"}} }
    let(:headers) { {'ACCEPT' => 'application/json'} }

  context "Register New User" do
      it "create valid user" do 
        post "/api/v1/users", params: params, headers: headers

        user_id =  User.last.id
        decodeHash = JsonWebToken.decode(session['user_id'])
        parsed_json_body = JSON(response.body)
        
        expect(user_id).to eq(decodeHash["user_id"])
        expect(parsed_json_body["token"]).to eq(session['user_id'])
        expect(response).to have_http_status :created
      end  

      it "is invalid due to duplication" do 
        User.create(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")
        post "/api/v1/users", params: dublicate_params, headers: headers
       expect(response).to_not have_http_status :created
      end  
   end

   context "Update User" do 
     it "is valid update" do 
        put  "/api/v1/users/" + user.id.to_s , params: update_params , headers: headers
   
        updated_user = User.find(user.id)
        password = BCrypt::Password.new(updated_user.password_digest)
        expect(password).to eq("111111")
        expect(updated_user.full_name).to eq("Joseph J. Law")
        expect(response).to have_http_status :success
     end

     it "is invalid update" do 
        put  "/api/v1/users/" + user.id.to_s , params: invalid_update_params , headers: headers
        expect(response).to_not have_http_status 422
     end
   end


   context "Email" do
      it "is a registed email" do
        p user.email
        post "/api/v1/users/check_email", params: { email: "test@gmail.com"} , headers: headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["switch"]).to eq(false)
        expect(response).to have_http_status :success
      end
      it "is a not registed email" do 
        p user.email
        post "/api/v1/users/check_email", params: { email: "test232329993@gmail.com"} , headers: headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["switch"]).to eq(true)
        expect(response).to have_http_status :success
      end
   end 
   context "User" do
      it "exists" do 
        p user.email
        post "/api/v1/users/check_existed_email", params: { email: "test@gmail.com"} , headers: headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["switch"]).to eq(true)
        expect(response).to have_http_status :success
      end
      it " does not exist" do 
        p user.email
        post "/api/v1/users/check_existed_email", params: { email: "test232323@gmail.com"} , headers: headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["switch"]).to eq(false)
        expect(response).to have_http_status :success
      end
   end 

   context "Delete User" do
    it "successfully delete user" do
       delete  "/api/v1/users/" + user.id.to_s , headers: headers
       delete_user = User.find_by_id(user.id)
       expect(delete_user).to be_blank
       expect(response).to have_http_status :success
    end
   end


end