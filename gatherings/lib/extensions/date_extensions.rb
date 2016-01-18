module DateExtensions
  extend ActiveSupport::Concern

  module ClassMethods
  
    def today
      self.current.beginning_of_day
    end

  end

end

DateTime.send(:include, DateExtensions)
