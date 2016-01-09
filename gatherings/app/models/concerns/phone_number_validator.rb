class PhoneNumberValidator < ActiveModel::EachValidator
  
  PHONE_NUMBER_REGEX = //

  def validate_each(record, attribute, value)
    if value.present? || !options[:allow_blank]
      # if !value.is_a?(ActiveSupport::TimeZone) || (options[:us_only] && !ActiveSupport::TimeZone.us_zones.any?{|tz| tz.name == value.name})
      #   record.errors[attribute] << (options[:message] || "is not a known timezone")
      # end
    end
  end

end
