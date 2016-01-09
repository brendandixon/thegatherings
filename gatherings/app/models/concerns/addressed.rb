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
    self.country = :us unless self.country.present?
  end

  module ClassMethods

    def has_address_of(*address_fields)
      options = address_fields.extract_options!
      
      self.address_fields = address_fields

      before_validation :ensure_country if self.address_fields.any?{|f| [:country, :postal_code].include?(f) }
      
      unless options[:allow_blank]
        validates_presence_of :street_primary if self.address_fields.include?(:street_primary)
        validates_presence_of :city if self.address_fields.include?(:city)
        validates_presence_of :state if self.address_fields.include?(:state)
        validates_presence_of :postal_code if self.address_fields.include?(:postal_code)
        validates_presence_of :time_zone if self.address_fields.include?(:time_zone)
      end
      
      validates :postal_code, zipcode: {allow_blank: true, country_code_attribute: :country} if self.address_fields.include?(:postal_code)
      validates :time_zone, time_zone: {allow_blank: true, us_only: true} if self.address_fields.include?(:time_zone)
    end

  end

end
