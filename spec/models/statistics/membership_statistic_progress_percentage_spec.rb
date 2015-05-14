require 'spec_helper'

describe MembershipStatisticProgressPercentage do

  describe "#calculate" do
    it "should calculate the proper value" do
      challenge = create(:challenge, chapters_to_read: 'Mar 1 -7')
      challenge.generate_readings
      membership = create(:membership, challenge: challenge)
      membership.membership_readings[0..3].each do |mr|
        mr.state = 'read'
        mr.save!
      end

      stat = MembershipStatisticProgressPercentage.new(membership: membership)

      expect(stat.calculate).to eq 57
    end
  end


end