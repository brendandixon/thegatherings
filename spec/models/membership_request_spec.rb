# == Schema Information
#
# Table name: membership_requests
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  message      :text(65535)
#  responded_on :datetime
#  status       :string(25)
#

require 'rails_helper'

describe MembershipRequest, type: :model do

  before :context do
    @community = create(:community)
    @gathering = create(:gathering, community: @community)
    @member = create(:member)
    @join_community = create(:membership, :as_member, group: @community, member: @member)
  end

  after :context do
    Membership.delete_all
    Gathering.delete_all
    Community.delete_all
    Member.delete_all
  end

  before do
    @membership_request = build(:membership_request, member: @member, gathering: @gathering)
  end

  it 'requires a member' do
    @membership_request.member = nil
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:member)
  end

  it 'rejects members not affiliated with the Community' do
    @join_community.delete
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:member)
    @join_community = create(:membership, :as_member, group: @community, member: @member)
  end

  it 'requires a gathering' do
    @membership_request.gathering = nil
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:gathering)
  end

  it 'rejects members participating in the Gathering' do
    @join_gathering = create(:membership, :as_member, group: @gathering, member: @member)
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:member)
    @join_gathering.delete
  end

  it 'requires a sent on date on or before today' do
    @membership_request.sent_on = 1.year.from_now
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:sent_on)
  end

  it 'accepts today for the sent on date' do
    @membership_request.sent_on = DateTime.current
    expect(@membership_request).to be_valid
    expect(@membership_request.errors).to_not have_key(:sent_on)
  end

  it 'accepts past dates for the sent on date' do
    @membership_request.sent_on = 1.week.ago
    expect(@membership_request).to be_valid
    expect(@membership_request.errors).to_not have_key(:sent_on)
  end

  it 'accepts today for the expires on date' do
    @membership_request.expires_on = DateTime.current
    expect(@membership_request).to be_valid
    expect(@membership_request.errors).to_not have_key(:expires_on)
  end

  it 'accepts past dates for the expires on date' do
    @membership_request.expires_on = 1.week.ago
    expect(@membership_request).to be_valid
    expect(@membership_request.errors).to_not have_key(:expires_on)
  end

  it 'requires the expires on date to be after the sent on date' do
    @membership_request.sent_on = 1.week.ago
    @membership_request.expires_on = 2.weeks.ago
    expect(@membership_request).to be_invalid
    expect(@membership_request.errors).to have_key(:expires_on)
  end

  it 'ensures the sent on date is set to the beginning of the day' do
    t = DateTime.current.beginning_of_day
    @membership_request.sent_on = t + 5.hours
    expect(@membership_request).to be_valid
    expect(@membership_request.sent_on).to eq(t)
    expect(@membership_request.errors).to_not have_key(:sent_on)
  end

  it 'ensures the expires on date is set to the end of the day' do
    t = DateTime.current.end_of_day
    @membership_request.expires_on = t - 5.hours
    expect(@membership_request).to be_valid
    expect(@membership_request.expires_on).to eq(t)
    expect(@membership_request.errors).to_not have_key(:expires_on)
  end

  context do
    before do
      @membership_request.save
    end

    after do
      @membership_request.delete
    end

    it 'requires a sent on date on persisted requests' do
      @membership_request.sent_on = nil
      @membership_request.expires_on = 1.week.from_now
      expect(@membership_request).to be_invalid
      expect(@membership_request.errors).to have_key(:sent_on)
    end

    it 'requires an expires on date on persisted requests' do
      @membership_request.sent_on = 1.week.ago
      @membership_request.expires_on = nil
      expect(@membership_request).to be_invalid
      expect(@membership_request.errors).to have_key(:expires_on)
    end

    it 'can be answered' do
      @membership_request.answer!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_answered
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'answered requests are not completed' do
      @membership_request.answer!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to_not be_completed
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'can be accepted' do
      @membership_request.accept!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_accepted
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'accepted requests are completed' do
      @membership_request.accept!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_completed
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'can be dismissed' do
      @membership_request.dismiss!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_dismissed
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'dismissed requests are completed' do
      @membership_request.dismiss!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_completed
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'a dismissed request can be accepted' do
      @membership_request.dismiss!
      @membership_request.accept!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_accepted
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'an accepted request can be dismissed' do
      @membership_request.accept!
      @membership_request.dismiss!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_dismissed
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'answering does not change an accepted request' do
      @membership_request.accept!
      @membership_request.answer!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to be_accepted
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end

    it 'answering resets a dismissed request' do
      @membership_request.dismiss!
      @membership_request.answer!
      expect(@membership_request).to_not be_changed
      expect(@membership_request).to be_valid
      expect(@membership_request).to_not be_dismissed
      expect(@membership_request).to be_answered
      expect(@membership_request.responded_on).to be_acts_like(:time)
    end
  end

end
