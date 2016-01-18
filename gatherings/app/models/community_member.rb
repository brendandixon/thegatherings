# == Schema Information
#
# Table name: community_members
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  community_id :integer          not null
#  roles        :integer          default(0)
#  active_on    :datetime         not null
#  inactive_on  :datetime
#

class CommunityMember < ActiveRecord::Base
  belongs_to :member
  belongs_to :community

  validates_datetime :active_on
  validates_datetime :inactive_on, after: :active_on, allow_blank: true
end
