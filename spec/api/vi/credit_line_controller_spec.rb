require 'rails_helper'
require 'jwt_token'
require 'bcrypt'
include SessionsHelper

describe Api::V1::CreditLinesController, type: :request do 
    let(:user) {User.create(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")}
    let(:token_headers) { {'ACCEPT' => 'application/json', 'Authorization' => JsonWebToken.encode({ user_id: user.id}) } }
    let(:invalid_token_headers) { {'ACCEPT' => 'application/json', 'Authorization' => "234324324234" }}
    before :each do 
       user.credit_lines.create(limit: 10000, interest: 0.35, balance: 10000, number_of_days: 30)
       user.credit_lines.create(limit: 20000, interest: 0.25, balance: 20000, number_of_days: 30)
    end


    context "Index" do 

      it "display list with valid token" do
        get "/api/v1/credit_lines", params: { }, headers: token_headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body.size).to eq(2)
        expect(parsed_json_body).to be_an_instance_of Array
      end

      it "is not authorized to acess with invalid token" do
        get "/api/v1/credit_lines", params: { }, headers: invalid_token_headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["error"]).to  eq('Invalid Request')
        expect(response).to have_http_status :unauthorized
      end
    end

    context "Show" do 
      it "display list with valid token" do
        get "/api/v1/credit_lines/" + CreditLine.first.id.to_s, params: { }, headers: token_headers
        parsed_json_body = JSON(response.body)

        expect(parsed_json_body["credit_line"]["user_id"]).to eq(CreditLine.first.id)
        expect(parsed_json_body["payment_cycle"]).to be_nil
        expect(parsed_json_body["transactions"]).to eq([])
        expect(response).to have_http_status :success
      end

      it "is not authorized to acess with invalid token" do
        get "/api/v1/credit_lines/" + CreditLine.first.id.to_s, params: { }, headers: invalid_token_headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["error"]).to  eq('Invalid Request')
        expect(response).to have_http_status :unauthorized
      end
    end

    context "Delete" do 
      it "with valid token" do
        delete "/api/v1/credit_lines/" + CreditLine.first.id.to_s, params: { }, headers: token_headers
        expect(response).to have_http_status :success
      end

      it "can not delete with invalid id" do
        delete "/api/v1/credit_lines/" + "123213", params: { }, headers: token_headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["error"]).to  eq('Invalid Request') 
        expect(response).to have_http_status 500
      end

      it "is not authorized to acess with invalid token" do
        delete "/api/v1/credit_lines/" + CreditLine.first.id.to_s, params: { }, headers: invalid_token_headers
        parsed_json_body = JSON(response.body)
        expect(parsed_json_body["error"]).to  eq('Invalid Request')
        expect(response).to have_http_status :unauthorized
      end
    end


end