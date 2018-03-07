module ActiveDates
  extend ActiveSupport::Concern

  included do
    before_validation :ensure_active

    validates_datetime :active_on, on_or_before: :today
    validates_datetime :inactive_on, on_or_after: :active_on, allow_blank: true

    if self < ApplicationRecord
      t = self.to_s.tableize
      scope :active_on, lambda{|dt| where("#{t}.active_on <= ? AND (#{t}.inactive_on IS NULL OR #{t}.inactive_on < ?)", dt, dt)}
      scope :active_after, lambda{|dt| where("#{t}.active_on > ?", dt)}
      scope :active_before, lambda{|dt| where("#{t}.active_on < ?", dt)}
      scope :is_active, lambda{ active_on(DateTime.current) }

      scope :inactive_on, lambda{|dt| where("#{t}.inactive_on <= ?", dt)}
      scope :inactive_after, lambda{|dt| where("#{t}.inactive_on > ?", dt)}
      scope :inactive_before, lambda{|dt| where("#{t}.inactive_on < ?", dt)}
      scope :is_inactive, lambda{ inactive_on(DateTime.current) }
    end
  end

  def active?(dt = DateTime.current)
    self.active_on.present? && self.active_on <= dt && (self.inactive_on.blank? || self.inactive_on > dt)
  end

  def inactive?
    self.inactive_on.present? && self.inactive_on <= DateTime.current
  end

  def activate!
    if self.inactive_on.present?
      self.active_on = DateTime.current
      self.inactive_on = nil
      self.save!
    end
  end

  def deactivate!
    self.inactive_on = DateTime.current if self.inactive_on.blank?
    self.save!
  end

  protected

    def ensure_active
      self.active_on = DateTime.current if !self.persisted? && self.active_on.blank?
    end

end
