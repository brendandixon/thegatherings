# == Schema Information
#
# Table name: assigned_overseers
#
#  id            :bigint(8)        not null, primary key
#  membership_id :bigint(8)        not null
#  gathering_id  :bigint(8)        not null
#  active_on     :datetime         not null
#  inactive_on   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AssignedOverseer < ApplicationRecord
  include Authority::Abilities
  include ActiveDates

  self.authorizer_name = 'CampusAuthorizer'

  FORM_FIELDS = [:membership_id, :gathering_id, :active_on, :inactive_on]

  belongs_to :gathering
  belongs_to :membership

  validates :gathering, belonging: {models: [Gathering]}
  validates :membership, belonging: {models: [Membership]}

  validate :has_valid_membership

  scope :for_campus, lambda{|campus| joins(:gathering).where("gatherings.campus_id = ?", campus)}
  scope :for_campuses, lambda{|*campuses| joins(:gathering).where("gatherings.campus_id IN (?)", campuses)}
  scope :for_community, lambda{|community| joins(:gathering).where("gatherings.community_id = ?", community.id)}
  scope :for_gathering, lambda{|gathering| where(gathering_id: gathering.id)}

  scope :for_member, lambda{|member| joins(:membership).where(memberships: {member: member})}
  scope :for_membership, lambda{|membership| where(membership: membership)}


  class << self

    def activate!(gathering, membership)
      overseer = AssignedOverseer.for_gathering(gathering).for_membership(membership).take
      if overseer.blank?
        overseer = self.create(gathering: gathering, membership: membership)
      elsif overseer.inactive?
        overseer.activate!
      end
      overseer
    end
    alias :oversee! :activate!

    def deactivate!(gathering, membership)
      overseer = AssignedOverseer.for_gathering(gathering).for_membership(membership).take
      overseer.deactivate! if overseer.present?
      overseer
    end

  end

  protected

    def has_valid_membership
      return if self.membership.blank? || self.gathering.blank?

      if !self.membership.to?(self.gathering.campus)
        self.errors.add(:membership, "is not a member of the Gathering campus")
      elsif !self.membership.as_overseer?
        self.errors.add(:membership, "is not a designated campus Overseer")
      end
    end

end
