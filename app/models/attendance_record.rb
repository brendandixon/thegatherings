# == Schema Information
#
# Table name: attendance_records
#
#  id            :integer          not null, primary key
#  meeting_id    :integer
#  membership_id :integer
#  attended      :boolean          default(FALSE), not null
#

class AttendanceRecord < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'GatheringAuthorizer'

  belongs_to :meeting, inverse_of: :attendance_records
  belongs_to :membership, inverse_of: :attendance_records

  validates_presence_of :meeting

  validates_presence_of :membership
  validate :is_gathering_member

  validates_inclusion_of :attended, in: [true, false]

  scope :for_meeting, lambda{|meeting| where(meeting: meeting)}
  scope :for_member, lambda{|member| joins(:membership).where(memberships: {member_id: member.id})}

  scope :as_absent, lambda{where(attended: false)}
  scope :as_present, lambda{where(attended: true)}

  def for_gathering?(gathering)
    self.membership.present? && self.membership.to?(gathering)
  end

  def for_member?(member)
    self.membership.present? && self.membership.for?(member)
  end

  def absent
    self.attended = false
  end

  def absent!
    absent
    self.save
  end

  def absent?
    !self.attended
  end

  def attend
    self.attended = true
  end

  def attend!
    attend
    self.save
  end

  def attended?
    self.attended
  end

  def campus
    self.gathering.campus if self.gathering.present?
  end

  def community
    self.gathering.community if self.gathering.present?
  end

  def gathering
    self.meeting.gathering if self.meeting.present?
  end

  private

    def is_gathering_member
      return if self.errors.has_key?(:membership) || self.errors.has_key?(:meeting)
      return if self.membership.to?(self.meeting.gathering) && self.membership.active?(self.meeting.datetime)
      self.errors.add(:membership, "#{self.membership.member.full_name} is not a member of #{self.gathering}")
    end

end
