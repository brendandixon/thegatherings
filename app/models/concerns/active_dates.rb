module ActiveDates
  extend ActiveSupport::Concern

  included do
    before_validation :ensure_active_on

    validates_datetime :active_on, on_or_before: :today
    validates_datetime :inactive_on, after: :active_on, allow_blank: true
  end

  protected

    def ensure_active_on
      self.active_on = DateTime.current if !self.persisted? && self.active_on.blank?
    end

end
