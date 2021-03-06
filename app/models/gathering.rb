# == Schema Information
#
# Table name: gatherings
#
#  id               :bigint(8)        not null, primary key
#  community_id     :bigint(8)        not null
#  campus_id        :bigint(8)        not null
#  name             :string(255)
#  description      :text(65535)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  country          :string(255)
#  postal_code      :string(255)
#  time_zone        :string(255)
#  meeting_starts   :datetime
#  meeting_ends     :datetime
#  meeting_day      :integer
#  meeting_time     :integer
#  meeting_duration :integer
#  minimum          :integer
#  maximum          :integer
#  open             :boolean          default(TRUE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Gathering < ApplicationRecord
  include Authority::Abilities
  include Addressed
  include InTimeZone
  include Joinable
  include Taggable

  MEETING_DURATION_DEFAULT = 90.minutes

  WEEKDAYS = %w(monday tuesday wednesday thursday friday saturday sunday)

  FORM_FIELDS = ADDRESS_FIELDS + TIME_ZONE_FIELDS + [:campus_id, :name, :description, :meeting_starts, :meeting_ends, :meeting_day, :meeting_time, :meeting_duration, :minimum, :maximum, :open]

  belongs_to :community
  belongs_to :campus

  has_many :checkups, inverse_of: :gathering, dependent: :destroy
  has_many :meetings, inverse_of: :gathering, dependent: :destroy

  has_many :memberships, as: :group, dependent: :destroy
  has_many :requests, inverse_of: :gathering, dependent: :destroy

  has_many :members, through: :memberships
  has_many :assigned_overseers, inverse_of: :gathering, dependent: :destroy

  has_many :preferences, inverse_of: :gathering, dependent: :nullify

  after_initialize :ensure_defaults, unless: :persisted?

  before_validation :ensure_community

  validates :community, belonging: {models: [Community]}
  validates :campus, belonging: {models: [Campus]}
  validate :community_owns_campus

  validates_length_of :name, within: 4..255
  validates_length_of :description, within: 25..1000

  validates_datetime :meeting_starts
  validates_datetime :meeting_ends, after: :meeting_starts, allow_blank: true
  validates_numericality_of :meeting_day, only_integer: true, greater_than_or_equal_to: 0, less_than: 7
  validates_numericality_of :meeting_time, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 24.hours-1
  validates_numericality_of :meeting_duration, only_integer: true, greater_than_or_equal_to: 30.minutes, less_than_or_equal_to: 24.hours

  validates_numericality_of :minimum, only_integer: true, greater_than_or_equal_to: 2
  validates_numericality_of :maximum, only_integer: true, greater_than_or_equal_to: 2
  validate :minimum_to_maximum

  scope :for_campus, lambda{|campus| where(campus_id: campus.id)}
  scope :for_campuses, lambda{|*campuses| where(campus_id: campuses)}
  scope :for_community, lambda{|community| where(community_id: community)}

  scope :is_open, lambda{|f = true| where(open: f)}

  scope :meets_on, lambda{|*days| where(meeting_day: days)}
  scope :meets_at, lambda{|times| where(meeting_time: times)}

  class<<self

    def meeting_days
      @@meeting_days ||= begin
                          md = []
                          WEEKDAYS.each_with_index{|d, i| md << [I18n.t(d, scope:[:common]), i]}
                          md
                        end
    end

    def meeting_durations
      @@meeting_durations ||= [30, 60, 90, 120].map{|d| [d, d.minutes]}
    end

  end

  def ensure_defaults
    today = DateTime.current.beginning_of_day
    self.meeting_day = 1 if self.meeting_day.blank?
    self.meeting_time = 19.hours if self.meeting_time.blank?
    self.meeting_duration = MEETING_DURATION_DEFAULT if self.meeting_duration.blank?
    self.meeting_starts = today if self.meeting_starts.blank?

    self.time_zone = TheGatherings::Application.default_time_zone if self.time_zone.blank?

    self.minimum = 6 if self.minimum.blank?
    self.maximum = 12 if self.maximum.blank?
  end

  def belongs_to?(group)
    (group.is_a?(Campus) && self.campus == group) || (group.is_a?(Community) && self.community == group)
  end

  def active_assigned_overseers(dt = DateTime.current)
    self.assigned_overseers.active_on(dt)
  end

  def is_active_assigned_overseer?(member, dt = DateTime.current)
    self.active_assigned_overseers(dt).for_member(member).exists?
  end

  def meeting_starts=(v)
    v = Timeliness.parse(v, :datetime) if v.is_a?(String)
    v = v.beginning_of_day if v.acts_like?(:time)
    write_attribute(:meeting_starts, v)
  end

  def meeting_ends=(v)
    v = Timeliness.parse(v, :datetime) if v.is_a?(String)
    v = v.end_of_day if v.acts_like?(:time)
    write_attribute(:meeting_ends, v)
  end

  def started_by?(dt = DateTime.current)
    dt >= self.meeting_starts
  end

  def ended_by?(dt = DateTime.current)
    self.meeting_ends.present? && dt >= self.meeting_ends
  end

  def first_meeting
    next_meeting(self.meeting_starts)
  end

  def last_meeting
    prior_meeting(self.meeting_ends)
  end

  def meeting_on?(dt = DateTime.current)
    dt = dt.in_time_zone(zone=Time.find_zone(self.time_zone))
    dt = dt.beginning_of_day
    dt.to_date == next_meeting(dt).to_date
  end

  def meetings_since(dt = DateTime.current)
    nm = [next_meeting(dt.beginning_of_day)]
    pm = prior_meeting
    until nm.last == pm
      m = next_meeting(nm.last.end_of_day)
      break if nm.last == m
      nm << m
    end
    nm
  end

  def next_meeting(dt = DateTime.current)
    Time.use_zone(self.time_zone) do
      mt = self.meeting_starts

      dt = dt.in_time_zone
      mt = mt.in_time_zone

      dt = mt if dt < mt

      mt = mt.years_since(dt.year - mt.year) if dt.year > mt.year
      mt = mt.beginning_of_year.days_since(dt.yday-1).beginning_of_week.days_since(self.meeting_day).beginning_of_day
      mt = mt.advance(seconds: self.meeting_time)
      mt = mt.weeks_since(1) if dt > mt
      mt = mt.weeks_ago(1) if ended_by?(mt)
      mt
    end
  end

  def next_meetings(dt = DateTime.current, n = 1)
    nm = [next_meeting(dt)]
    1.upto(n-1) do |i|
      m = next_meeting(nm[i-1].end_of_day)
      break if nm.last == m
      nm << m
    end
    nm
  end

  def prior_meeting(dt = DateTime.current)
    if dt < self.meeting_starts
      next_meeting(self.meeting_starts.beginning_of_day)
    else
      Time.use_zone(self.time_zone) do
        mt = self.meeting_starts

        dt = dt.in_time_zone
        mt = mt.in_time_zone

        dt = self.meeting_ends if ended_by?(dt)

        mt = mt.years_since(dt.year - mt.year) if dt.year > mt.year
        mt = mt.beginning_of_year.days_since(dt.yday-1).beginning_of_week.days_since(self.meeting_day).beginning_of_day
        mt = mt.advance(seconds: self.meeting_time)
        mt = mt.weeks_ago(1) if dt <= mt
        mt = mt.weeks_since(1) if !started_by?(mt)
        mt
      end
    end
  end

  def prior_meetings(dt = DateTime.current, n = 1)
    pm = [prior_meeting(dt)]
    1.upto(n-1) do |i|
      m = prior_meeting(pm[i-1].beginning_of_day)
      break if pm.last == m
      pm << m
    end
    pm
  end

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |g|
      g['memberships'] = self.memberships.as_json(deep: true) if options[:deep]
      g['path'] = campus_path(self)
      g['campus_path'] = campus_path(self.campus)
      g['community_path'] = community_path(self.community)
      g['attendees_path'] = attendees_gathering_path(self)
      g['health_path'] = health_gathering_path(self)
      g['requests_path'] = gathering_requests_path(self)
    end
  end

  def to_s
    self.name
  end

  protected

    def community_owns_campus
      return if self.errors.has_key?(:community) || self.errors.has_key?(:campus)
      self.errors.add(:campus, "#{self.campus} is not part of the #{self.community} community") unless self.community == self.campus.community
    end

    def ensure_community
      return if self.community.is_a?(Community) || self.campus.blank?
      self.community = self.campus.community
    end

    def minimum_to_maximum
      unless self.errors.has_key?(:minimum) || self.errors.has_key?(:maximum) || self.minimum <= self.maximum
        self.errors.add(:minimum, I18n.t(:invalid_minimum, scope: [:errors, :gathering]))
        self.errors.add(:maximum, I18n.t(:invalid_maximum, scope: [:errors, :gathering]))
      end
    end

end
