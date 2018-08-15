# == Schema Information
#
# Table name: memberships
#
#  id          :bigint(8)        not null, primary key
#  member_id   :bigint(8)        not null
#  group_id    :bigint(8)        unsigned, not null
#  group_type  :string(255)      not null
#  active_on   :datetime         not null
#  inactive_on :datetime
#  role        :string(25)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Membership < ApplicationRecord
  include Authority::Abilities
  include ActiveDates

  FORM_FIELDS = [:member_id, :group_id, :group_type, :active_on, :inactive_on, :role]

  belongs_to :group, polymorphic: true, inverse_of: :memberships
  belongs_to :member, inverse_of: :memberships
  
  has_many :attendance_records, inverse_of: :membership, dependent: :destroy
  has_many :assigned_overseers, inverse_of: :membership, dependent: :destroy

  has_one :preference, inverse_of: :membership, dependent: :destroy
  has_many :requests, inverse_of: :membership, dependent: :destroy

  validates :member, belonging: {models: [Member]}
  validates :group, belonging: {models: [Community, Campus, Gathering]}
  
  validates_inclusion_of :role, in: RoleContext::ROLES
  validate :is_role_allowed
  validate :allows_overseer_downgrade

  scope :in_role, lambda{|roles| where(role: roles)}
  scope :as_assistant, lambda{in_role(RoleContext::ASSISTANTS)}
  scope :as_leader, lambda{in_role(RoleContext::LEADERS)}
  scope :as_member, lambda{in_role(RoleContext::MEMBERS)}
  scope :as_overseer, lambda{in_role(RoleContext::OVERSEERS)}
  scope :as_participant, lambda{in_role(RoleContext::PARTICIPANTS)}
  scope :as_visitor, lambda{in_role(RoleContext::VISITORS)}

  scope :in_collection, lambda{|klass| where(group_type: klass.to_s)}
  scope :in_communities, lambda{in_collection(Community)}
  scope :in_campuses, lambda{in_collection(Campus)}
  scope :in_gatherings, lambda{in_collection(Gathering)}

  scope :for_group, lambda{|group| where(group: group)}
  scope :for_campus, lambda{|campus| for_group(campus)}
  scope :for_campuses, lambda{|*campuses| for_group(campuses)}
  scope :for_community, lambda{|community| for_group(community)}
  scope :for_gathering, lambda{|gathering| for_group(gathering)}

  scope :for_member, lambda{|member| where(member: member)}
  scope :affiliated_with, lambda{|group, member| for_group(group).for_member(member) }

  class << self

    def activate!(group, member)
      m = Membership.affiliated_with(group, member).take
      if m.present?
        m.activate!
      else
        m = join!(group, member)
      end
      m
    end

    def become!(group, member, role)
      m = Membership.affiliated_with(group, member).take
      if m.present?
        m.update(role: role)
      else
        m = self.create(group: group, member: member, role: role) if m.blank?
      end
      m
    end

    def deactivate!(group, member)
      m = Membership.affiliated_with(group, member).take
      m.deactivate! unless m.blank?
      m
    end

    def join!(group, member, role = nil)
      role = RoleContext::MEMBER if role.blank?
      m = Membership.affiliated_with(group, member).take rescue nil
      m ||= self.create(group: group, member: member, role: role)
      m
    end

  end

  RoleContext::ROLES.each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def become_#{role}
        self.role == "#{role}"
      end

      def become_#{role}!
        become_#{role}
        save!
      end

      def is_#{role}?
        self.role == "#{role}"
      end
    METHODS
  end

  def as_assistant?
    RoleContext::ASSISTANTS.include?(self.role)
  end

  def as_leader?
    RoleContext::LEADERS.include?(self.role)
  end

  def as_member?
    RoleContext::MEMBERS.include?(self.role)
  end

  def as_overseer?
    RoleContext::OVERSEERS.include?(self.role)
  end

  def as_participant?
    RoleContext::PARTICIPANTS.include?(self.role)
  end

  def as_visitor?
    RoleContext::VISITORS.include?(self.role)
  end

  def for?(member)
    member.present? && self.member_id == member.id
  end

  def to?(group)
    group.present? && self.group_type == group.class.to_s && self.group_id == group.id
  end

  def community
    self.group.is_a?(Community) ? self.group : self.group.community if self.group.present?
  end

  def campus
    self.group.is_a?(Campus) ? self.group : nil
  end

  def gathering
    self.group.is_a?(Gathering) ? self.group : nil
  end

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |m|
      m['member'] = self.member.as_json
      m['path'] = membership_path(self)
      m['community_path'] = community_path(self.community)
      m['campus_path'] = self.campus.present? ? campus_path(self.campus) : nil
      m['gathering_path'] = self.gathering.present? ? gathering_path(self.gathering) : nil
    end
  end

  protected

    def allows_overseer_downgrade
      return if self.assigned_overseers.empty?
      return if RoleContext::OVERSEERS.include?(self.role)
      self.errors.add(:role, "#{self.role} is disallowed while assigned Gatherings to oversee")
    end

    def is_role_allowed
      return if RoleContext::is_role_allowed?(self.group, self.role)
      self.errors.add(:role, "is not allowed for #{self.group.class.to_s.pluralize}")
    end

end
