require 'spec_helper'

describe Member::MembershipsController do
  let(:owner){create(:user)}
  let(:challenge){create(:challenge, :with_membership, owner: owner)}
  let(:user){create(:user)}
  let(:membership){challenge.join_new_member(user)}

  before(:each) do
    sign_in :user, user
  end

  describe 'DELETE#destroy' do
    it "finds the current_user membership" do
      delete :destroy, id: membership
      expect(assigns(:membership)).to eql(membership)
    end

    it "destroys the membership", skip: true do
      pending
      expect{
        delete :destroy, id: membership
      }.to change(Membership,:count).by(-1)
    end

    it "redirects to the challenge url" do
      delete :destroy, id: membership
      expect(response).to redirect_to challenge
    end
  end

  describe  'POST#create' do
    let(:newchallenge){create(:challenge_with_readings, :with_membership, owner: owner)}

    it "redirects to the challenge page after joining as a logged in user" do
      somechallenge = create(:challenge)  #uses factorygirl
      post :create, challenge_id: somechallenge.id
      expect(response).to redirect_to [:member, somechallenge]
    end

    it "creates a membership" do
      newchallenge
      expect {
        post :create, challenge_id: newchallenge
      }.to change(Membership, :count).by(1)
    end

    it "associates statistics with membership" do
      ch = newchallenge
      m = ch.memberships.first
      MembershipCompletion.new(m)
      number_of_stats = MembershipStatistic.descendants.size
      expect {
        # this slightly ridiculous expectation is because the stats are created
        # for the challenge creator as well as the new member.  #todo
        post :create, challenge_id: newchallenge
      }.to change(MembershipStatistic, :count).by(number_of_stats)
    end
    it "sends the user a Thanks for joining email" do
      challenge = create(:challenge_with_readings, begindate: Date.today+1)
      Sidekiq::Testing.inline! do
        expect {
          post :create, challenge_id: challenge
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
        expect(ActionMailer::Base.deliveries.last.subject).to include "Thanks for joining"
      end
    end
    it "sends the user an email with today's reading if there is reading for today" do
      newchallenge
      Sidekiq::Testing.inline! do
        expect {
          post :create, challenge_id: newchallenge
        }.to change { ActionMailer::Base.deliveries.count }.by(2)
        expect(ActionMailer::Base.deliveries.last.subject).to include "Bible Challenge reading for"
      end
    end
  end

  context 'when the user has already joined' do
    describe 'GET#show  (my-membership)' do
      it "finds the current_users membership" do
        get :show, id: membership.id
        expect(assigns(:membership)).to eql(membership)
      end

      it "renders the :show template" do
        get :show, id: membership.id
        expect(response).to render_template :show
      end
    end
  end
end
