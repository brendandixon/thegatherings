# == Schema Information
#
# Table name: campuses
#
#  id                 :string(36)       not null, primary key
#  community_id       :string(36)       not null
#  name               :string(255)
#  contact_first_name :string(255)
#  contact_last_name  :string(255)
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
#

class Campus < ActiveRecord::Base
  include Addressed
  include UniqueID

  has_address_of :street_primary, :street_secondary, :city, :state, :country, :postal_code, :time_zone, allow_blank: true

  belongs_to :community

end
