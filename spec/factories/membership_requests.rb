# == Schema Information
#
# Table name: membership_requests
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  message      :text(65535)
#  responded_on :datetime
#  status       :string(25)
#

FactoryGirl.define do
  factory :membership_request, class: 'MembershipRequest' do
    association :member, factory: :member
    association :gathering, factory: :gathering
    sent_on 2.weeks.ago
    expires_on 1.week.from_now
  end
end
