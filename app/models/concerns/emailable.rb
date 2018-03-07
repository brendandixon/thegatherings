module Emailable
  extend ActiveSupport::Concern

  EMAIL_FIELDS = [:email]

  included do
    validates_length_of :email, within: 6..255
    validates :email, email: true

    if self < ApplicationRecord
      validates_uniqueness_of :email
      
      scope :with_email, lambda{|email| where(email: email)}
    end
  end

end
