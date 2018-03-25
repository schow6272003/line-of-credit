require 'rails_helper'
require 'jwt_token'
require 'bcrypt'
include SessionsHelper

describe Api::V1::SessionsController, type: :request do 
    let(:user) {User.create(full_name: "John Doe", email: 'test@gmail.com', password: "123456", password_confirmation: "123456")}
    let(:headers) { {'ACCEPT' => 'application/json'} }

    context "Session" do 
      it "is created" do
        post "/api/v1/sessions", params: {session: { email: user.email, password: "123456"} }, headers: headers

        decodeHash = JsonWebToken.decode(session['user_id'])
        parsed_json_body = JSON(response.body)
        expect(user.id).to eq(decodeHash["user_id"])
        expect(parsed_json_body["user_id"]).to eq(session['user_id'])
        expect(response).to have_http_status :success
      end

      it "is destroyed" do
        delete "/api/v1/sessions/" + user.id.to_s, params: {}, headers: headers
        expect(session['user_id']).to be_nil
        expect(response).to have_http_status :success
      end
    end

end