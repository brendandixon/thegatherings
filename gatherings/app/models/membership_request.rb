# == Schema Information
#
# Table name: membership_requests
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  accepted     :boolean          default(FALSE)
#

class MembershipRequest < ActiveRecord::Base
  belongs_to :member
  belongs_to :gathering

  validates_datetime :sent_on
  validates_datetime :expires_on, after: :sent_on
end
