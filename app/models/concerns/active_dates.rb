module ActiveDates
  extend ActiveSupport::Concern

  included do
    before_validation :ensure_active

    validates_datetime :active_on, on_or_before: :today
    validates_datetime :inactive_on, after: :active_on, allow_blank: true

    if self < ActiveRecord::Base
      scope :active_on, lambda{|dt| where("active_on <= ? AND (inactive_on IS NULL OR inactive_on < ?)", dt, dt)}
      scope :active_after, lambda{|dt| where("active_on > ?", dt)}
      scope :active_before, lambda{|dt| where("active_on < ?", dt)}
      scope :inactive_after, lambda{|dt| where("inactive_on > ?", dt)}
      scope :inactive_before, lambda{|dt| where("inactive_on < ?", dt)}
    end
  end

  def active?(dt = Time.zone.now)
    self.active_on.present? && self.active_on <= dt && (self.inactive_on.blank? || self.inactive_on > dt)
  end

  protected

    def ensure_active
      self.active_on = DateTime.current if !self.persisted? && self.active_on.blank?
    end

end
