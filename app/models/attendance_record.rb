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
  include Authority::Abilities

  belongs_to :member, required: true, inverse_of: :attendance_records
  belongs_to :gathering, required: true, inverse_of: :attendance_records

  validates :member, belonging: {models: [Member]}
  validates :gathering, belonging: {models: [Gathering]}
  validate :is_gathering_member

  validates_datetime :datetime, on_or_before: :today
  validate :is_valid_datetime

  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}
  scope :for_member, lambda{|member| where(member: member)}
  scope :for_datetime, lambda{|datetime| where(datetime: datetime)}

  def belongs_to_gathering?(gathering)
    gathering.is_a?(Gathering) && self.gathering_id == gathering.id
  end

  def belongs_to_member?(member)
    member.is_a?(Member) && self.member_id == member.id
  end

  private

    def is_gathering_member
      unless self.member.blank? || self.gathering.blank? || self.member.membership_in(self.gathering).present?
        self.errors.add(:member, "#{self.member.full_name} is not a member of #{self.gathering}")
      end
    end

    def is_valid_datetime
      unless self.gathering.blank? || self.datetime.blank? || self.gathering.meeting_on?(self.datetime)
        self.errors.add(:datetime, "is not a valid Gathering meeting day")
      end 
    end

end
