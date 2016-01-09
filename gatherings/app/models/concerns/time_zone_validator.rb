class TimeZoneValidator < ActiveModel::EachValidator
   
  def validate_each(record, attribute, value)
    if value.present? || !options[:allow_blank]
      value = ActiveSupport::TimeZone.new(value) if value.is_a?(String)
      if !value.is_a?(ActiveSupport::TimeZone) || (options[:us_only] && !ActiveSupport::TimeZone.us_zones.any?{|tz| tz.name == value.name})
        record.errors[attribute] << (options[:message] || "#{value} is not a known timezone")
      end
    end
  end

end
