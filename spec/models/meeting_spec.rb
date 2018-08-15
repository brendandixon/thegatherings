# == Schema Information
#
# Table name: meetings
#
#  id             :bigint(8)        not null, primary key
#  gathering_id   :bigint(8)        not null
#  occurs         :datetime         not null
#  canceled       :boolean          default(FALSE), not null
#  number_present :integer
#  number_absent  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
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

  it 'requires a occurs' do
    @meeting.occurs = nil
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:occurs)
  end

  it 'requires a occurs on or before today' do
    @meeting.occurs = 1.year.from_now
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:occurs)
  end

  it 'accepts a occurs on or after the first Gethering meeting' do
    @meeting.occurs = @gathering.prior_meeting
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:occurs)
  end

  it 'accepts past dates for the occurs' do
    @meeting.occurs = @gathering.first_meeting
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:occurs)
  end

  it 'rejects dates that occur after the Gathering ends' do
    me = @gathering.meeting_ends
    @gathering.meeting_ends = 2.months.ago
    @meeting.occurs = DateTime.current
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:occurs)
    @gathering.meeting_ends = me
  end

  it 'rejects dates that are not a Gathering meeting' do
    @meeting.occurs = @gathering.next_meeting + 1.day
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:occurs)
  end

  it 'accepts positive integers for the number absent' do
    @meeting.number_absent = 42
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_absent)
  end

  it 'accepts zero for the number absent' do
    @meeting.number_absent = 0
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_absent)
  end

  it 'accepts blank for the number absent' do
    @meeting.number_absent = nil
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_absent)
  end

  it 'rejects negative integers for the number absent' do
    @meeting.number_absent = -1
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:number_absent)
  end

  it 'accepts positive integers for the number present' do
    @meeting.number_present = 42
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_present)
  end

  it 'accepts zero for the number present' do
    @meeting.number_present = 0
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_present)
  end

  it 'accepts blank for the number present' do
    @meeting.number_present = nil
    expect(@meeting).to be_valid
    expect(@meeting.errors).to_not have_key(:number_present)
  end

  it 'rejects negative integers for the number present' do
    @meeting.number_present = -1
    expect(@meeting).to be_invalid
    expect(@meeting.errors).to have_key(:number_present)
  end

end
