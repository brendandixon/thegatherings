# See http://www.regular-expressions.info/email.html
class EmailValidator < ActiveModel::EachValidator
  
  PATTERN = /\s*[\w._%+-]+@[\w.-]+\.[A-Za-z]{2,}\s*/

  def validate_each(record, attribute, value)
    if value.present? || !options[:allow_blank]
      record.errors[attribute] << (options[:message] || I18n.t(:malformed, scope: [:errors, :email], email: value)) unless value =~ PATTERN
    end
  end

end
