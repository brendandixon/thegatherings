# == Schema Information
#
# Table name: role_names
#
#  id           :bigint(8)        not null, primary key
#  community_id :bigint(8)
#  group_type   :string(255)      not null
#  role         :string(255)
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class RoleName < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'CommunityAuthorizer'

  FORM_FIELDS = [:community_id, :group_type, :role, :name]

  class<<self

    def add_defaults!(community)
      return if community.blank?
      RoleName.transaction do
        ApplicationAuthorizer::COMMUNITY_ROLES.each do |role|
          community.role_names.create!(role: role, name: I18n.t(role, scope: :roles), group_type: Community)
        end
        ApplicationAuthorizer::CAMPUS_ROLES.each do |role|
          community.role_names.create!(role: role, name: I18n.t(role, scope: :roles), group_type: Campus)
        end
        ApplicationAuthorizer::GATHERING_ROLES.each do |role|
          community.role_names.create!(role: role, name: I18n.t(role, scope: :roles), group_type: Gathering)
        end
      end
    end

  end

  belongs_to :community

  validates :community, belonging: {models: [Community]}

  validates_inclusion_of :role, in: ApplicationAuthorizer::ROLES
  validates_inclusion_of :group_type, in: ApplicationHelper::GROUP_TYPES
  validates_length_of :name, in: 4..255

  validates_uniqueness_of :name, scope: [:community_id, :group_type]

  scope :for_community, lambda{|community| where(community: community)}
  scope :for_group, lambda{|group| where(group_type: group)}
  scope :for_role, lambda{|role| where(role: role)}

end
