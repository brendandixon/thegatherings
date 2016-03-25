# == Schema Information
#
# Table name: attendance_records
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  datetime     :datetime         not null
#

require 'rails_helper'

describe AttendanceRecord, type: :model do

  before :context do
    @affiliate = create(:member)
    @member = create(:member)
    @gathering = create(:gathering)
    create(:membership, :as_member, group: @gathering, member: @member)
  end

  after :context do
    Membership.delete_all
    Gathering.delete_all
    Member.delete_all
  end

  before do
    @attendance_record = build(:attendance_record, gathering: @gathering, member: @member)
  end

  it 'requires a member' do
    @attendance_record.member = nil
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:member)
  end

  it 'requires a gathering' do
    @attendance_record.gathering = nil
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:gathering)
  end

  it 'requires a datetime' do
    @attendance_record.datetime = nil
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:datetime)
  end

  it 'requires a datetime on or before today' do
    @attendance_record.datetime = 1.year.from_now
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:datetime)
  end

  it 'accepts a datetime on or after the first Gethering meeting' do
    @attendance_record.datetime = @gathering.prior_meeting
    expect(@attendance_record).to be_valid
    expect(@attendance_record.errors).to_not have_key(:datetime)
  end

  it 'accepts past dates for the datetime' do
    @attendance_record.datetime = @gathering.first_meeting
    expect(@attendance_record).to be_valid
    expect(@attendance_record.errors).to_not have_key(:datetime)
  end

  it 'rejects dates that occur after the Gathering ends' do
    me = @gathering.meeting_ends
    @gathering.meeting_ends = 2.months.ago
    @attendance_record.datetime = DateTime.current
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:datetime)
    @gathering.meeting_ends = me
  end

  it 'rejects dates that are not a Gathering meeting' do
    @attendance_record.datetime = @gathering.next_meeting + 1.day
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:datetime)
  end

  it 'requires the member to be part of the Gathering' do
    expect(@attendance_record).to be_valid
    expect(@attendance_record.errors).to_not have_key(:member)
  end

  it 'rejects members not a part of the Gathering' do
    @attendance_record.member = @affiliate
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:member)
  end

  context 'Belonging' do
    it 'returns true for the associated gathering' do
      expect(@attendance_record).to be_belongs_to_gathering(@gathering)
    end

    it 'returns false for a different gathering' do
      expect(@attendance_record).to_not be_belongs_to_gathering(create(:gathering))
    end

    it 'returns true for the associated member' do
      expect(@attendance_record).to be_belongs_to_member(@member)
    end

    it 'returns false for a different member' do
      expect(@attendance_record).to_not be_belongs_to_member(@affiliate)
    end
  end

end
