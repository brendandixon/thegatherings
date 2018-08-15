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

class Meeting < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'GatheringResourceAuthorizer'

  FORM_FIELDS = [:gathering_id, :occurs, :canceled]

  belongs_to :gathering, inverse_of: :meetings
  has_many :attendance_records, inverse_of: :meeting, dependent: :destroy

  validates_presence_of :gathering
  
  validates_datetime :occurs, on_or_before: :today
  validate :is_valid_meeting_time

  validates_inclusion_of :canceled, in: [true, false]

  validates_numericality_of :number_absent, greater_than_or_equal_to: 0, only_integer: true, allow_blank: true
  validates_numericality_of :number_present, greater_than_or_equal_to: 0, only_integer: true, allow_blank: true

  scope :for_campus, lambda{|campus| joins(:gathering).where('gatherings.campus_id = ?', campus)}
  scope :for_campuses, lambda{|*campuses| joins(:gathering).where('gatherings.campus_id IN (?)', campuses)}
  scope :for_community, lambda{|community| joins(:gathering).where('gatherings.community_id = ?', community)}
  scope :for_gathering, lambda{|gathering| where(gathering_id: gathering.id)}

  scope :for_occurs, lambda{|dt| where(occurs: dt)}
  
  scope :since, lambda{|dt| where("occurs >= ?", dt)}

  scope :by_occurs, lambda{order(:occurs)}

  def attendees
    self.attendance_records.map{|ar| ar.membership.member}
  end

  def attendance
    [number_present, number_present + number_absent]
  end

  def campus
    self.gathering.campus if self.gathering.present?
  end

  def community
    self.gathering.community if self.gathering.present?
  end

  def ensure_attendees
    self.gathering.memberships.active_on(self.occurs).each do |membership|
      next if membership.attendance_records.for_meeting(self).present?
      begin
        membership.attendance_records.create(meeting_id: self.id)
      rescue ActiveRecord::RecordNotUnique
      end
    end
  end

  def settle_attendance!
    raise Exception.new("Meeting is not yet over") if self.occurs > DateTime.now()
    self.number_present = self.attendance_records.as_present.count
    self.number_absent = self.attendance_records.as_absent.count
    save!
  end

  private

    def is_valid_meeting_time
      return if self.gathering.blank? || self.occurs.blank?
      self.errors.add(:occurs, "is not a valid Gathering meeting day") unless self.gathering.meeting_on?(self.occurs)
    end

end
