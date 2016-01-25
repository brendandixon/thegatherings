class BelongingValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors[attribute] << I18n.t(:missing, scope: [:errors, :common]) unless options[:allow_blank]
    elsif options[:models].present? && !options[:models].any?{|model| value.is_a?(model)}
      record.errors[attribute] << I18n.t(:illegal, scope: [:errors, :belonging], models: options[:models].map{|model| model.to_s.humanize })
    elsif !value.respond_to?("persisted?".to_sym)
      record.errors[attribute] << I18n.t(:not_a_model, scope: [:errors, :belonging])
    elsif value.new_record? && !options[:allow_new]
      record.errors[attribute] << I18n.t(:not_new, scope: [:errors, :belonging])
    end
  end

end
