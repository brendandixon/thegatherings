# == Schema Information
#
# Table name: preferences
#
#  id           :bigint(8)        not null, primary key
#  community_id :bigint(8)
#  member_id    :bigint(8)
#  campus_id    :bigint(8)
#  gathering_id :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Preference < ApplicationRecord
  include Authority::Abilities
  include Taggable

  FORM_FIELDS = []

  belongs_to :community, inverse_of: :preferences
  belongs_to :member, inverse_of: :preferences

  belongs_to :campus, inverse_of: :preferences
  belongs_to :gathering, inverse_of: :preferences

  validates :community, belonging: {models: [Community]}
  validates :member, belonging: {models: [Member]}
  
  validates_uniqueness_of :member, scope: [:community]

  validates :campus, belonging: {models: [Campus]}, allow_blank: true
  validate :has_active_campus_membership

  validates :gathering, belonging: {models: [Gathering]}, allow_blank: true
  validate :has_active_gathering_membership

  scope :for_campus, lambda{|campus| where(campus: campus)}
  scope :for_campuses, lambda{|*campuses| where(campus_id: campuses)}
  scope :for_community, lambda{|community| where(community: community)}
  scope :for_member, lambda{|member| where(member: member)}

  def as_json(*)
    super.except(*JSON_EXCLUDES).tap do |p|
      id = p['id']
      campus_id = p['campus_id']
      community_id = p['community_id']
      gathering_id = p['gathering_id']
      p['path'] = campus_path(id, format: :json)
      p['member_path'] = member_path(p['member_id'], format: :json)
      p['community_path'] = community_path(community_id, format: :json)
      p['campus_path'] = campus_id.present? ? campus_path(campus_id, format: :json) : nil
      p['gathering_path'] = gathering_id.present? ? gathering_path(gathering_id, format: :json) : nil
      p['add_taggings_path'] = add_preference_taggings_path(id, format: :json)
      p['remove_taggings_path'] = remove_preference_taggings_path(id, format: :json)
      p['set_taggings_path'] = set_preference_taggings_path(id, format: :json)
    end
  end

  protected

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

end
