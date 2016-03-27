# == Schema Information
#
# Table name: attendance_records
#
#  id            :integer          not null, primary key
#  meeting_id    :integer
#  membership_id :integer
#  attended      :boolean          default(FALSE), not null
#

require 'rails_helper'

describe AttendanceRecord, type: :model do

  before do
    @gathering = build_stubbed(:gathering)
    @meeting = build_stubbed(:meeting, gathering: @gathering)
    @membership = build_stubbed(:membership, group: @gathering)
    @attendance_record = build(:attendance_record, meeting: @meeting, membership: @membership)
  end

  it 'requires a Meeting' do
    @attendance_record.meeting = nil
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:meeting)
  end

  it 'requires a Membership' do
    @attendance_record.membership = nil
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:membership)
  end

  it 'rejects Members not part of the Gatherings' do
    @attendance_record.membership = build_stubbed(:membership)
    expect(@attendance_record).to be_invalid
    expect(@attendance_record.errors).to have_key(:membership)
  end

  context 'Membership' do
    before do
      @member = create(:member)
      @gathering = create(:gathering)
      @meeting = create(:meeting, gathering: @gathering)
      @membership = create(:membership, :as_member, group: @gathering, member: @member)
      @attendance_record = build(:attendance_record, meeting: @meeting, membership: @membership)
    end

    it 'accepts Gathering Members' do
      expect(@attendance_record).to be_valid
      expect(@attendance_record.errors).to_not have_key(:membership)
    end

    it 'will mark a member attended' do
      @attendance_record.attend!
      expect(@attendance_record).to be_attended
      expect(@attendance_record).to be_valid
      expect(@attendance_record.errors).to_not have_key(:attended)
    end

    it 'will mark a member absent' do
      @attendance_record.absent!
      expect(@attendance_record).to be_absent
      expect(@attendance_record).to be_valid
      expect(@attendance_record.errors).to_not have_key(:attended)
    end
  end

end
