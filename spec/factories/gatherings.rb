# == Schema Information
#
# Table name: gatherings
#
#  id               :integer          not null, primary key
#  community_id     :integer          not null
#  name             :string(255)
#  description      :text(65535)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  time_zone        :string(255)
#  meeting_starts   :datetime
#  meeting_ends     :datetime
#  meeting_day      :integer
#  meeting_time     :integer
#  meeting_duration :integer
#  childcare        :boolean          default(FALSE), not null
#  childfriendly    :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  minimum          :integer
#  maximum          :integer
#  open             :boolean          default(TRUE), not null
#  campus_id        :integer
#

FactoryGirl.define do
  factory :gathering, class: 'Gathering' do
    name "The Gathering of Orthodox Baptists"
    description <<-DESCRIPTION
      A very long description that actually says nothing about anything.
      A very long description that actually says nothing about anything.
      A very long description that actually says nothing about anything.
      A very long description that actually says nothing about anything.
      A very long description that actually says nothing about anything.
    DESCRIPTION
    street_primary "1234 56th Avenue"
    city "Seattle"
    state "WA"
    postal_code "98117"
    time_zone TheGatherings::Application.default_time_zone
    meeting_starts 1.year.ago.beginning_of_week
    meeting_ends 1.year.from_now
    meeting_time 19.hours
    meeting_day 2
    meeting_duration 90.minutes

    association :community, factory: :community
    association :campus, factory: :campus
  end
end
