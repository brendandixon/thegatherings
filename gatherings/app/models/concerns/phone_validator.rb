class PhoneValidator < ActiveModel::EachValidator
  
  PATTERN = /\d{3}\.\d{3}\.\d{4}/

  def validate_each(record, attribute, value)
    if value.present? || !options[:allow_blank]
      record.errors[attribute] << (options[:message] || I18n.t(:malformed_phone, scope: [:errors, :messages], phone: value)) unless value =~ PATTERN
    end
  end

end
