module Emailable
  extend ActiveSupport::Concern

  EMAIL_FIELDS = [:email]

  included do
    validates :email, email: true
    validates_length_of :email, within: 6..255, unless: Proc.new{|em| em.errors.has_key?(:email)}

    if self < ApplicationRecord
      validates_uniqueness_of :email, unless: Proc.new{|em| em.errors.has_key?(:email)}
      
      scope :with_email, lambda{|email| where(email: email)}
    end
  end

end
