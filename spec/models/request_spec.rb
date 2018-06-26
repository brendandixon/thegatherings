# == Schema Information
#
# Table name: requests
#
#  id           :bigint(8)        not null, primary key
#  member_id    :bigint(8)        not null
#  campus_id    :bigint(8)        not null
#  gathering_id :bigint(8)
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  message      :text(65535)
#  responded_on :datetime
#  status       :string(25)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Request, type: :model do

  before :context do
    @campus = create(:campus)
    @gathering = create(:gathering, campus: @campus)
    @member = create(:member)
    @join_campus = create(:membership, :as_member, group: @campus, member: @member)
  end

  after :context do
    Membership.delete_all
    Gathering.delete_all
    Community.delete_all
    Member.delete_all
  end

  before do
    @request = build(:request, campus: @campus, member: @member, gathering: @gathering)
  end

  it 'requires a campus' do
    @request.campus = nil
    @request.gathering = nil
    expect(@request).to be_invalid
    expect(@request.errors).to have_key(:campus)
    expect(@request.errors).to_not have_key(:gathering)
  end

  it 'requires a member' do
    @request.member = nil
    expect(@request).to be_invalid
    expect(@request.errors).to have_key(:member)
  end

  it 'accepts a missing gathering' do
    @request.gathering = nil
    expect(@request).to be_valid
    expect(@request.errors).to_not have_key(:gathering)
  end

  it 'rejects members participating in the Gathering' do
    @join_gathering = create(:membership, :as_member, group: @gathering, member: @member)
    expect(@request).to be_invalid
    expect(@request.errors).to have_key(:member)
    @join_gathering.delete
  end

  it 'requires a sent on date on or before today' do
    @request.sent_on = 1.year.from_now
    expect(@request).to be_invalid
    expect(@request.errors).to have_key(:sent_on)
  end

  it 'accepts today for the sent on date' do
    @request.sent_on = DateTime.current
    expect(@request).to be_valid
    expect(@request.errors).to_not have_key(:sent_on)
  end

  it 'accepts past dates for the sent on date' do
    @request.sent_on = 1.week.ago
    expect(@request).to be_valid
    expect(@request.errors).to_not have_key(:sent_on)
  end

  it 'accepts today for the expires on date' do
    @request.expires_on = DateTime.current
    expect(@request).to be_valid
    expect(@request.errors).to_not have_key(:expires_on)
  end

  it 'accepts past dates for the expires on date' do
    @request.expires_on = 1.week.ago
    expect(@request).to be_valid
    expect(@request.errors).to_not have_key(:expires_on)
  end

  it 'requires the expires on date to be after the sent on date' do
    @request.sent_on = 1.week.ago
    @request.expires_on = 2.weeks.ago
    expect(@request).to be_invalid
    expect(@request.errors).to have_key(:expires_on)
  end

  it 'ensures the sent on date is set to the beginning of the day' do
    t = DateTime.current.beginning_of_day
    @request.sent_on = t + 5.hours
    expect(@request).to be_valid
    expect(@request.sent_on).to eq(t)
    expect(@request.errors).to_not have_key(:sent_on)
  end

  it 'ensures the expires on date is set to the end of the day' do
    t = DateTime.current.end_of_day
    @request.expires_on = t - 5.hours
    expect(@request).to be_valid
    expect(@request.expires_on).to be_within(1.second).of(t)
    expect(@request.errors).to_not have_key(:expires_on)
  end

  it 'allows an empty responded on date if status is empty' do
    @request.status = nil
    @request.responded_on = nil
    expect(@request).to be_valid
  end

  it 'requires a responded on date if status exists' do
    @request.responded_on = nil
    Request::STATES.each do |state|
      @request.status = state
      expect(@request).to_not be_valid
    end
  end

  context do
    before do
      @request.save
    end

    after do
      @request.delete
    end

    it 'requires a sent on date on persisted requests' do
      @request.sent_on = nil
      @request.expires_on = 1.week.from_now
      expect(@request).to be_invalid
      expect(@request.errors).to have_key(:sent_on)
    end

    it 'requires an expires on date on persisted requests' do
      @request.sent_on = 1.week.ago
      @request.expires_on = nil
      expect(@request).to be_invalid
      expect(@request.errors).to have_key(:expires_on)
    end

    it 'can be answered' do
      @request.answer!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_answered
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'answered requests are not completed' do
      @request.answer!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to_not be_completed
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'can be accepted' do
      @request.accept!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_accepted
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'accepted requests are completed' do
      @request.accept!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_completed
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'can be dismissed' do
      @request.dismiss!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_dismissed
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'dismissed requests are completed' do
      @request.dismiss!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_completed
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'a dismissed request can be accepted' do
      @request.dismiss!
      expect(@request).to be_dismissed

      @request.accept!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_accepted
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'an accepted request can be dismissed' do
      @request.accept!
      expect(@request).to be_accepted

      @request.dismiss!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_dismissed
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'answering does not change an accepted request' do
      @request.accept!
      @request.answer!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to be_accepted
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'answering resets a dismissed request' do
      @request.dismiss!
      expect(@request).to be_dismissed

      @request.answer!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to_not be_dismissed
      expect(@request).to be_answered
      expect(@request.responded_on).to be_acts_like(:time)
    end

    it 'can be unanswered' do
      @request.accept!
      expect(@request).to be_accepted

      @request.unanswer!
      expect(@request).to_not be_changed
      expect(@request).to be_valid
      expect(@request).to_not be_dismissed
      expect(@request).to be_unanswered
      expect(@request.responded_on).to be_blank
    end
  end

end
