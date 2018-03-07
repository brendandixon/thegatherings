module Addressed
  extend ActiveSupport::Concern

  ADDRESS_FIELDS = [:street_primary, :street_secondary, :city, :state, :country, :postal_code]

  included do
    before_validation :ensure_country

    validates_length_of :street_primary, within: 5..255, if: Proc.new {is_required_address_field?(:street_primary)}
    validates_length_of :street_secondary, within: 5..255, allow_blank: true
    validates_length_of :city, within: 2..255, if: Proc.new {is_required_address_field?(:city)}
    validates_length_of :state, is: 2, if: Proc.new {is_required_address_field?(:state)}
    validates_length_of :country, within: 2..10, if: Proc.new {is_required_address_field?(:country)}

    validates :postal_code, zipcode: {country_code_attribute: :country}, if: Proc.new {is_required_address_field?(:postal_code)}
  end

  protected

    def ensure_country
      self.country = :us if !self.persisted? && self.country.blank?
    end

    def is_required_address_field?(field)
      true
    end

end
