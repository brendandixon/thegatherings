# == Schema Information
#
# Table name: gatherings
#
#  id               :string(36)       not null, primary key
#  community_id     :string(36)       not null
#  name             :string(255)
#  description      :text(65535)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  time_zone        :string(255)
#  meeting_starts   :datetime
#  meeting_ends     :datetime
#  meeting_day      :string(25)
#  meeting_time     :time
#  meeting_duration :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Gathering < ActiveRecord::Base
  include Addressed
  include AgeGroups
  include Genders
  include LifeStages
  include Relationships
  include UniqueID

  MEETING_DURATION_DEFAULT = 90

  TIME_BASE = Time.new(2000,1,1).utc.beginning_of_day
  TIME_DB_FORMAT = "2000-01-01 %H:%M:00 UTC"
  TIME_DISPLAY_FORMAT = "%l:%M %p"

  WEEKDAYS = %w(sunday monday tuesday wednesday thursday friday saturday)

  has_address_of :street_primary, :street_secondary, :city, :state, :country, :postal_code, allow_blank: true

  belongs_to :community, required: true

  after_initialize :ensure_defaults
  before_validation :normalize_meeting_day
  before_validation :normalize_meeting_times

  validates :name, presence: true, length: {minimum: 5, maximum: 255}
  validates :description, presence: true

  validates :meeting_day, presence: true, inclusion: {in: WEEKDAYS}, unless: :new_record?
  validates :meeting_time, presence: true, unless: :new_record?
  validates :meeting_duration, presence: true, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 24*60}, unless: :new_record?

  class<<self

    def meeting_days
      @@meeting_days ||= WEEKDAYS.map{|d| [I18n.t(d, scope:[:common]), d]}
    end

    def meeting_durations
      @@meeting_durations ||= [30, 60, 90, 120].map{|d| [d, d]}
    end

    def meeting_times
      @@meeting_times ||= begin
                            d1 = TIME_BASE
                            d2 = d1.end_of_day
                            a = []
                            while d1 <= d2
                              a << [d1.strftime(TIME_DISPLAY_FORMAT), d1.strftime(TIME_DB_FORMAT)]
                              d1 = d1.advance(minutes: 30)
                            end
                            a
                          end
    end

  end

  # TODO: Move date handling into a concern
  # TODO: Add an ISO8601 validator -- see https://gist.github.com/philipashlock/8830168 for regular expressions
  def meeting_ends=(v)
    v = Time.new($1, $2, $3) if v.is_a?(String) && v =~ /^(\d{4,4})\-(\d{2,2})\-(\d{2,2})(T(\d{2,2}:\d{2,2}:\d{2,2})?)?.*/
    write_attribute(:meeting_ends, v)
  end

  def meeting_starts=(v)
    v = Time.zone.parse(v) if v.is_a?(String)
    write_attribute(:meeting_starts, v)
  end

  private

    def ensure_defaults
      today = DateTime.current.beginning_of_day
      self.meeting_day = :tuesday if self.meeting_day.blank?
      self.meeting_time = today.advance(hours: 19).to_s(TIME_DB_FORMAT) if self.meeting_time.blank?
      self.meeting_duration = MEETING_DURATION_DEFAULT if self.meeting_duration.blank?
      self.meeting_starts = today if self.meeting_starts.blank?

      self.time_zone = TheGatherings::Application.default_time_zone if self.time_zone.blank?
    end

    def normalize_meeting_day
      self.meeting_day = self.meeting_day.to_s.downcase unless self.meeting_day.blank?
    end

    def normalize_meeting_times
      [:meeting_starts, :meeting_ends].each do |mt|
        v = self.send(mt)
        self.send("#{mt}=", v.beginning_of_day) if v.present? && v.acts_like_time?
      end
    end

end
