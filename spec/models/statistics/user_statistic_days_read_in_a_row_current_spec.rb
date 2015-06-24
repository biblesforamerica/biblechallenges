require 'spec_helper'

describe UserStatisticDaysReadInARowCurrent do
  describe "#update" do
    it "should calculate the proper value for user reading on consecutive days" do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-7')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticDaysReadInARowCurrent.new(user: user)
      challenge.readings[0..4].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

        Timecop.return
      expect(user_stat.value.to_i).to eq 5
    end

    it "should calculate the proper value for user reading on consecutive days in separate challenges" do
      challenge1 = create(:challenge, chapters_to_read: 'Mark 1-7')
      challenge2 = create(:challenge, chapters_to_read: 'Lu 1-7')
      user = create(:user)
      membership1 = challenge1.join_new_member(user)
      membership2 = challenge2.join_new_member(user)
      challenge1.generate_readings
      challenge2.generate_readings
      user_stat = UserStatisticDaysReadInARowCurrent.new(user: user)
      challenge1.readings[0..2].each do |mr| # 3 chapters in challenge 1
        create(:membership_reading, membership: membership1, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end
      challenge2.readings[0..2].each do |mr| # 3 chaptres in challenge 2
        create(:membership_reading, membership: membership2, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end
      challenge1.readings[0..2].each do |mr| # 3 chapters in challenge 1
        create(:membership_reading, membership: membership1, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end
     expect(user_stat.value.to_i).to eq 9
      Timecop.return
    end


    it "calculates the right streak with a skipped day in between" do
      challenge = create(:challenge, chapters_to_read: 'Mark 1-10')
      user = challenge.members.first
      membership = challenge.memberships.first
      challenge.generate_readings
      user_stat = UserStatisticDaysReadInARowCurrent.new(user: user)
      challenge.readings[0..3].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

      Timecop.travel(1.day) #skip one day
      challenge.readings[4..8].each do |mr|
        create(:membership_reading, membership: membership, reading: mr)
        user_stat.update
        Timecop.travel(1.day)
      end

      expect(user_stat.value.to_i).to eq 5
      Timecop.return
    end
  end
end
