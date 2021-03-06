require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "#google_oauth2" do
    before do
      mock_auth_hash("google_oauth2", "pp@example.com")
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it "should successfully create a user" do
      expect {
        post :google_oauth2, provider: :google_oauth2
      }.to change{ User.count }.by(1)
    end

    it "should redirect first-time sign-ups to root url" do
      post :google_oauth2, provider: :google_oauth2
      expect(response).to redirect_to root_path
    end
  end
end
