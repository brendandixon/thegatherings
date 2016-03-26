# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Community < ActiveRecord::Base
  include Authority::Abilities
  include ActiveDates
  include Joinable

  has_many :campuses
  has_many :gatherings

  validates_length_of :name, within: 10..255

  def campus
  end
  
  def community
    self
  end

  def to_s
    self.name
  end
  
end
