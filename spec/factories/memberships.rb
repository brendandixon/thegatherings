# == Schema Information
#
# Table name: memberships
#
#  id          :integer          not null, primary key
#  member_id   :integer          not null
#  group_id    :integer          not null
#  group_type  :string(255)      not null
#  active_on   :datetime         not null
#  inactive_on :datetime
#  participant :string(25)
#  role        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :community_admin, class: 'Membership' do
    association :member, factory: :administrator
    association :group, factory: :community
    active_on 6.months.ago
    role :administrator
  end

  factory :community_leader, class: 'Membership' do
    association :member, factory: :leader
    association :group, factory: :community
    active_on 6.months.ago
    role :leader
  end

  factory :community_coach, class: 'Membership' do
    association :member, factory: :coach
    association :group, factory: :community
    active_on 6.months.ago
    role :coach
  end

  factory :community_assistant, class: 'Membership' do
    association :member, factory: :assistant
    association :group, factory: :community
    active_on 6.months.ago
    role :assistant
  end

  factory :community_participant, class: 'Membership' do
    association :member, factory: :participant
    association :group, factory: :community
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end

  factory :community_membership, class: 'Membership' do
    association :member, factory: :member
    association :group, factory: :community
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end

  factory :campus_admin, class: 'Membership' do
    association :member, factory: :administrator
    association :group, factory: :campus
    active_on 6.months.ago
    role :administrator
  end

  factory :campus_leader, class: 'Membership' do
    association :member, factory: :leader
    association :group, factory: :campus
    active_on 6.months.ago
    role :leader
  end

  factory :campus_coach, class: 'Membership' do
    association :member, factory: :coach
    association :group, factory: :campus
    active_on 6.months.ago
    role :coach
  end

  factory :campus_assistant, class: 'Membership' do
    association :member, factory: :assistant
    association :group, factory: :campus
    active_on 6.months.ago
    role :assistant
  end

  factory :campus_participant, class: 'Membership' do
    association :member, factory: :participant
    association :group, factory: :campus
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end

  factory :campus_membership, class: 'Membership' do
    association :member, factory: :member
    association :group, factory: :campus
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end

  factory :gathering_leader, class: 'Membership' do
    association :member, factory: :leader
    association :group, factory: :gathering
    active_on 6.months.ago
    role :leader
  end

  factory :gathering_coach, class: 'Membership' do
    association :member, factory: :coach
    association :group, factory: :gathering
    active_on 6.months.ago
    role :coach
  end

  factory :gathering_assistant, class: 'Membership' do
    association :member, factory: :assistant
    association :group, factory: :gathering
    active_on 6.months.ago
    role :assistant
  end

  factory :gathering_participant, class: 'Membership' do
    association :member, factory: :participant
    association :group, factory: :gathering
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end

  factory :gathering_visitor, class: 'Membership' do
    association :member, factory: :visitor
    association :group, factory: :gathering
    active_on 6.months.ago
    participant Membership::PARTICIPANT_VISITOR
  end

  factory :gathering_membership, class: 'Membership' do
    association :member, factory: :member
    association :group, factory: :gathering
    active_on 6.months.ago
    participant Membership::PARTICIPANT_MEMBER
  end
end
