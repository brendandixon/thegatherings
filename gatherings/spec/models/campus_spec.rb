# == Schema Information
#
# Table name: campuses
#
#  id                 :integer          not null, primary key
#  community_id       :integer          not null
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

require 'rails_helper'

RSpec.describe Campus, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
