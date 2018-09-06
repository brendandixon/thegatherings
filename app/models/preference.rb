# == Schema Information
#
# Table name: preferences
#
#  id            :bigint(8)        not null, primary key
#  community_id  :bigint(8)        not null
#  campus_id     :bigint(8)
#  gathering_id  :bigint(8)
#  membership_id :bigint(8)        not null
#  host          :boolean
#  lead          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Preference < ApplicationRecord
  include Authority::Abilities
  include Taggable

  FORM_FIELDS = []

  belongs_to :community, inverse_of: :preferences
  belongs_to :campus, inverse_of: :preferences
  belongs_to :gathering, inverse_of: :preferences
  belongs_to :membership, inverse_of: :preference

  has_one :member, inverse_of: :preferences, through: :membership

  before_validation :ensure_defaults, if: :new_record?

  validates :community, belonging: {models: [Community]}
  validates :membership, belonging: {models: [Membership]}

  validate :is_community_membership
  validates_uniqueness_of :membership, scope: :community

  validates :campus, belonging: {models: [Campus]}, allow_blank: true
  validate :has_active_campus_membership

  validates :gathering, belonging: {models: [Gathering]}, allow_blank: true
  validate :has_active_gathering_membership

  scope :for_campus, lambda{|campus| where(campus: campus)}
  scope :for_campuses, lambda{|*campuses| where(campus_id: campuses)}
  scope :for_community, lambda{|community| where(community: community)}
  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}
  scope :for_member, lambda{|member| joins(:membership).where("memberships.member_id = ?", member.id)}
  scope :for_membership, lambda{|membership| where(membership: membership)}

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |p|
      p['tags'] = self.tags.as_json if options[:deep]
      p['path'] = preference_path(self)
      p['membership_path'] = membership_path(self.membership)
      p['member_path'] = member_path(self.membership.member)
      p['community_path'] = community_path(self.community)
      p['campus_path'] = self.campus.present? ? campus_path(self.campus) : nil
      p['gathering_path'] = self.gathering.present? ? gathering_path(self.gathering) : nil
      p['add_taggings_path'] = add_preference_taggings_path(self)
      p['remove_taggings_path'] = remove_preference_taggings_path(self)
      p['set_taggings_path'] = set_preference_taggings_path(self)
    end
  end

  protected

    def ensure_defaults
      return unless self.community.present? && self.member.present?
      self.campus ||= self.member.default_campus(self.community)
      self.gathering ||= self.member.default_gathering(self.community)
    end

    def has_active_campus_membership
      return unless self.campus.present?
      return if Membership.for_member(self.member).for_group(self.campus).is_active.exists?
      self.errors.add(:campus, "The preferred Campus must have an active membership")
    end

    def has_active_gathering_membership
      return unless self.gathering.present?
      return if Membership.for_member(self.member).for_group(self.gathering).is_active.exists?
      self.errors.add(:gathering, "The preferred Gathering must have an active membership")
    end

    def is_community_membership
      return unless self.membership.present?
      if self.membership.inactive?
        self.errors.add(:membership, "The membership is not active")
      elsif !self.membership.to?(self.community)
        self.errors.add(:membership, "The membership is not to Community")
      end
    end

end
