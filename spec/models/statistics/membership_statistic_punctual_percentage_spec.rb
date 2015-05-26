require 'spec_helper'

describe MembershipStatisticPunctualPercentage do

  describe "#calculate" do

    it "should calculate a perfect percentage" do
      # four chapters each read on the right day
      challenge = create(:challenge_with_readings, 
                         chapters_to_read: 'Matt 1-4', begindate: Date.today)

      membership = create(:membership, challenge: challenge)
      readings = challenge.readings
      first_day = challenge.readings.order(:date).first.date
      create(:membership_reading, reading: readings[0], membership: membership, updated_at: first_day)
      create(:membership_reading, reading: readings[1], membership: membership, updated_at: first_day + 1)
      create(:membership_reading, reading: readings[2], membership: membership, updated_at: first_day + 2)
      create(:membership_reading, reading: readings[3], membership: membership, updated_at: first_day + 3)


      Timecop.travel(first_day + 3.days)

      stat = MembershipStatisticPunctualPercentage.new(membership: membership)
      expect(stat.calculate).to eq 100
      Timecop.return
    end
  end

end
