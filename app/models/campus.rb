# == Schema Information
#
# Table name: campuses
#
#  id                 :integer          not null, primary key
#  community_id       :integer          not null
#  name               :string(255)
#  email              :string(255)
#  phone              :string(255)
#  street_primary     :string(255)
#  street_secondary   :string(255)
#  city               :string(255)
#  state              :string(255)
#  postal_code        :string(255)
#  time_zone          :string(255)
#  country            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active_on          :datetime
#  inactive_on        :datetime
#

class Campus < ActiveRecord::Base
  include Authority::Abilities
  include ActiveDates
  include Addressed
  include Joinable
  include Phoneable

  has_address_of :street_primary, :street_secondary, :city, :state, :country, :postal_code, :time_zone

  belongs_to :community, required: true, inverse_of: :campuses

  has_many :gatherings, inverse_of: :campus

  validates :community, belonging: {models: [Community]}
  validates_length_of :name, within: 10..255

  validates :email, email: true

  def campus
    self
  end

  def to_s
    self.name
  end

end
