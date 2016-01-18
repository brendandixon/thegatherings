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
#  meeting_day      :string(25)
#  meeting_time     :datetime
#  meeting_duration :integer
#  childcare        :boolean          default(FALSE)
#  childfriendly    :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  mininum          :integer
#  maximum          :integer
#  open             :boolean          default(TRUE)
#

require "rails_helper"

RSpec.describe Gathering, type: :model do
end
