# == Schema Information
#
# Table name: gatherings
#
#  id               :string(36)       primary key
#  community_id     :string(36)       not null
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
#  meeting_day      :string(25)
#  meeting_time     :time
#  meeting_duration :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "rails_helper"

RSpec.describe Gathering, type: :model do
end
