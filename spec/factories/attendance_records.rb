# == Schema Information
#
# Table name: attendance_records
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  datetime     :datetime         not null
#

FactoryGirl.define do
  factory :attendance_record, class: 'AttendanceRecord' do
    association :member, factory: :participant
    association :gathering, factory: :gathering
    datetime { gathering.prior_meeting }
  end
end
