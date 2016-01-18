# == Schema Information
#
# Table name: attendance_records
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  datetime     :datetime         not null
#

class AttendanceRecord < ActiveRecord::Base
  belongs_to :member
  belongs_to :gathering

  validates_datetime :datetime
end
