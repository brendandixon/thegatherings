class TagsValidator < ActiveModel::EachValidator
   
  def validate_each(record, attribute, value)
    if value.present? || !options[:allow_blank]
      group = attribute.to_s.split('_')
      group = group.slice(0..-2) if group.last == 'list'
      group = group.join(' ')
      values = Array(value)
      unless values.present? || options[:allow_blank] == true
        record.errors[attribute] << (options[:message] || I18n.t(:missing, scope: [:errors, :tags]))
      else
        if options[:limit].present? && values.length > options[:limit]
          record.errors[attribute] << (options[:message] || I18n.t(:too_many, scope: [:errors, :tags], limit: options[:limit]))
        end
        values.each do |tag|
          unless options[:values].include?(tag)
            record.errors[attribute] << (options[:message] || I18n.t(:unknown, scope: [:errors, :tags], tag: tag, group: group))
          end
        end
      end
    end
  end

end
