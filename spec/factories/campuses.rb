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
#  active_on          :datetime
#  inactive_on        :datetime
#

FactoryGirl.define do
  factory :campus do
    name "Long-Lake Campus"
    contact_first_name "Billy"
    contact_last_name "Bob"
    street_primary "1234 56th Avenue"
    city "Seattle"
    state "WA"
    postal_code "98117"
    phone "123.555.7890"
    email "billy.bob@nomail.com"
    active_on 1.year.ago

    association :community, factory: :community
  end

  factory :closed_campus do
    name "Boarded Up and Gone Fellowship"
    contact_first_name "Billy"
    contact_last_name "Bob"
    street_primary "1234 56th Avenue"
    city "Seattle"
    state "WA"
    postal_code "98117"
    phone "123.555.7890"
    email "billy.bob@nomail.com"
    active_on 5.years.ago
    inactive_on DateTime.yesterday

    association :community, factory: :closed_community
  end
end
