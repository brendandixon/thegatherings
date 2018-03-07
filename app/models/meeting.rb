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

class Meeting < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'GatheringResourceAuthorizer'

  FORM_FIELDS = [:gathering_id, :datetime, :canceled]

  belongs_to :gathering, inverse_of: :meetings
  has_many :attendance_records, inverse_of: :meeting, dependent: :destroy

  validates_presence_of :gathering
  
  validates_datetime :datetime, on_or_before: :today
  validate :is_valid_datetime

  validates_inclusion_of :canceled, in: [true, false]

  scope :for_campus, lambda{|campus| joins(:gathering).where('gatherings.campus_id = ?', campus)}
  scope :for_campuses, lambda{|*campuses| joins(:gathering).where('gatherings.campus_id IN (?)', campuses)}
  scope :for_community, lambda{|community| joins(:gathering).for_community(community)}
  scope :for_gathering, lambda{|gathering| where(gathering_id: gathering.id)}

  scope :for_datetime, lambda{|dt| where(datetime: dt)}
  
  scope :since, lambda{|dt| where("datetime >= ?", dt)}

  scope :by_datetime, lambda{order(:datetime)}

  def attendees
    self.attendance_records.map{|ar| ar.membership.member}
  end

  def attendance
    [number_present, self.attendance_records.count]
  end

  def number_absent
    self.attendance_records.as_absent.count
  end

  def number_present
    self.attendance_records.as_present.count
  end

  def campus
    self.gathering.campus if self.gathering.present?
  end

  def community
    self.gathering.community if self.gathering.present?
  end

  def ensure_attendees
    self.gathering.memberships.active_on(self.datetime).each do |membership|
      next if membership.attendance_records.for_meeting(self).present?
      begin
        membership.attendance_records.create(meeting_id: self.id)
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end

  private

    def is_valid_datetime
      return if self.gathering.blank? || self.datetime.blank?
      self.errors.add(:datetime, "is not a valid Gathering meeting day") unless self.gathering.meeting_on?(self.datetime)
    end

end
