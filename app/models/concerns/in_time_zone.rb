class TimeZoneNameType < ActiveRecord::Type::String
  def cast(value)
    value.is_a?(ActiveSupport::TimeZone) ? super(value.name) : super
  end
end
ActiveModel::Type.register(:time_zone_name, TimeZoneNameType)
ActiveRecord::Type.register(:time_zone_name, TimeZoneNameType)

module InTimeZone
  extend ActiveSupport::Concern

  TIME_ZONE_FIELDS = [:time_zone]

  included do
    attribute :time_zone, :time_zone_name
    before_validation :ensure_time_zone

    validates :time_zone, time_zone: {us_only: true}
  end

  protected

    def ensure_time_zone
      self.time_zone = TheGatherings::Application.default_time_zone if !self.persisted? && self.time_zone.blank?
    end

end
