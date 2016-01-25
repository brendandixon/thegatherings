# Address field support
# 
# Recognized fields are:
#   :street_primary     string(255)
#   :street_secondary   string(255)
#   :city               string(255)
#   :state              string(2)
#   :country            string(2)
#   :postal_code        string(25)
#   :time_zone          string(255)
#
module Addressed
  extend ActiveSupport::Concern

  included do
    cattr_accessor :address_fields
  end

  def has_address_field?(field)
    self.class.address_fields.include?(field.to_sym)
  end

  def ensure_country
    self.country = :us if !self.persisted? && self.country.blank?
  end

  def ensure_time_zone
    self.time_zone = TheGatherings::Application.default_time_zone if !self.persisted? && self.time_zone.blank?
  end

  module ClassMethods

    def has_address_of(*address_fields)
      self.address_fields = address_fields

      before_validation :ensure_country if self.address_fields.any?{|f| [:country, :postal_code].include?(f) }
      before_validation :ensure_time_zone if self.address_fields.include?(:time_zone)
      
      validates_length_of :street_primary, within: 5..255 if self.address_fields.include?(:street_primary)
      validates_length_of :city, within: 2..255 if self.address_fields.include?(:city)
      validates_length_of :state, is: 2 if self.address_fields.include?(:state)
      validates_length_of :country, within: 2..10 if self.address_fields.include?(:country)
      
      validates :postal_code, zipcode: {country_code_attribute: :country} if self.address_fields.include?(:postal_code)
      validates :time_zone, time_zone: {us_only: true} if self.address_fields.include?(:time_zone)

      if self.address_fields.include?(:time_zone)
        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def time_zone=(v)
            v = v.name if v.is_a?(ActiveSupport::TimeZone)
            write_attribute(:time_zone, v)
          end
        METHODS
      end
    end

  end

end
