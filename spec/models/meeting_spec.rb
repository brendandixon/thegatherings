# == Schema Information
#
# Table name: meetings
#
#  id           :bigint(8)        not null, primary key
#  gathering_id :bigint(8)        not null
#  datetime     :datetime         not null
#  canceled     :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Meeting, type: :model do

  before do
    @gathering = build_stubbed(:gathering)
    @meeting = build(:meeting, gathering: @gathering)
  end

  it 'requires a Gathering' do
    @meeting.gathering = nil
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:gathering)
  end

  it 'requires a datetime' do
    @meeting.datetime = nil
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:datetime)
  end

  it 'requires a datetime on or before today' do
    @meeting.datetime = 1.year.from_now
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:datetime)
  end

  it 'accepts a datetime on or after the first Gethering meeting' do
    @meeting.datetime = @gathering.prior_meeting
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:datetime)
  end

  it 'accepts past dates for the datetime' do
    @meeting.datetime = @gathering.first_meeting
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:datetime)
  end

  it 'rejects dates that occur after the Gathering ends' do
    me = @gathering.meeting_ends
    @gathering.meeting_ends = 2.months.ago
    @meeting.datetime = DateTime.current
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:datetime)
    @gathering.meeting_ends = me
  end

  it 'rejects dates that are not a Gathering meeting' do
    @meeting.datetime = @gathering.next_meeting + 1.day
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:datetime)
  end

end
