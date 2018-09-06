# == Schema Information
#
# Table name: request_owners
#
#  id            :bigint(8)        not null, primary key
#  membership_id :bigint(8)        not null
#  request_id    :bigint(8)        not null
#  active_on     :datetime         not null
#  inactive_on   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RequestOwner < ApplicationRecord
  include Authority::Abilities
  include ActiveDates

  self.authorizer_name = 'CampusAuthorizer'

  FORM_FIELDS = [:membership_id, :request_id, :active_on, :inactive_on]

  belongs_to :membership
  belongs_to :request

  has_one :campus, inverse_of: :request_owners, through: :request
  has_one :community, inverse_of: :request_owners, through: :request
  has_one :member, inverse_of: :request_owners, through: :membership

  validates :membership, belonging: {models: [Membership]}
  validates :request, belonging: {models: [Request]}

  validate :has_valid_membership

  scope :for_campus, lambda{|campus| joins(:request).where("requests.campus_id = ?", campus)}
  scope :for_campuses, lambda{|*campuses| joins(:request).where("requests.campus_id IN (?)", campuses)}
  scope :for_community, lambda{|community| joins(:request).where("requests.community_id = ?", community.id)}
  scope :for_request, lambda{|request| where(request_id: request.id)}

  scope :for_member, lambda{|member| joins(:membership).where(memberships: {member: member})}
  scope :for_membership, lambda{|membership| where(membership: membership)}


  class << self

    def activate!(request, membership)
      owner = RequestOwner.for_request(request).for_membership(membership).take
      if owner.blank?
        owner = self.create(request: request, membership: membership)
      elsif owner.inactive?
        owner.activate!
      end
      owner
    end
    alias :own! :activate!

    def deactivate!(request, membership)
      owner = RequestOwner.for_request(request).for_membership(membership).take
      owner.deactivate! if owner.present?
      owner
    end

  end

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |r|
      r['member'] = self.member.as_json
      r['path'] = request_owner_path(self)
      r['community_path'] = community_path(self.community)
      r['campus_path'] = self.campus.present? ? campus_path(self.campus) : nil
    end
  end

  protected

    def has_valid_membership
      return if self.membership.blank? || self.request.blank?

      if !self.membership.to?(self.request.campus)
        self.errors.add(:membership, "is not a member of the Request campus")
      elsif !self.membership.as_overseer? && !self.membership.as_leader?
        self.errors.add(:membership, "is not a designated campus Leader or Overseer")
      end
    end

end
