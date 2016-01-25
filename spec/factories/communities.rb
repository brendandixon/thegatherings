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

FactoryGirl.define do
  factory :community do
    name "The Reformed Luthern Fellowship of Spirit-Filled Methodist Baptists"
    active_on 1.year.ago
  end

  factory :closed_community do
    name "Boarded Up and Gone Fellowship"
    active_on 5.years.ago
    inactive_on DateTime.yesterday
  end
end
