# == Schema Information
#
# Table name: communities
#
#  id               :string(36)       primary key
#  name             :string(255)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  time_zone        :string(255)
#  country          :string(255)
#  active_on        :date
#  inactive_on      :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Community < ActiveRecord::Base
  include Addressed
  include UniqueID

  has_address_of :street_primary, :street_secondary, :city, :state, :country, :postal_code, :time_zone

  before_validation :ensure_active_on

  validates_presence_of :active_on

  has_many :gatherings

  private

    def ensure_active_on
      self.active_on = DateTime.current if self.new_record?
    end
  
end
