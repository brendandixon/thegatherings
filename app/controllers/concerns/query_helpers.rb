module QueryHelpers
  extend ActiveSupport::Concern

  included do 
  end

  class_methods do
  end

  def to_bool(v = nil)
    [true, 'true', 't', 'yes', 'y'].include?(v)
  end

  def to_days(values = nil)
    d = []
    values.split(',').each do |v|
      v = v.to_s.downcase
      v = case v
          when 'monday', 'mon' then 0
          when 'tuesday', 'tues' then 1
          when 'wednesday', 'wed' then 2
          when 'thursday', 'thurs' then 3
          when 'friday', 'fri' then 4
          when 'saturday', 'sat' then 5
          when 'sunday', 'sun' then 6
          else
            nil
          end
      d << v if v.present?
    end if values.is_a?(String)
    d
  end

  def to_time_range(v)
    case v
    when 'evening' then 17.hours..22.hours
    when 'afternoon' then 12.hours..17.hours
    when 'morning' then 6.hours..12.hours
    end
  end

end
