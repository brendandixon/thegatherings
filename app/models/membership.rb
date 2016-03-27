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

class Membership < ActiveRecord::Base
  include Authority::Abilities
  include ActiveDates
  include Taggable

  belongs_to :group, polymorphic: true, required: true, inverse_of: :memberships
  belongs_to :member, required: true, inverse_of: :memberships
  has_many :attendance_records, inverse_of: :membership

  before_validation :evaluate_active
  before_validation :normalize_role

  validates :member, belonging: {models: [Member]}
  validates :group, belonging: {models: [Community, Campus, Gathering]}

  validates_inclusion_of :participant, in: ApplicationAuthorizer::PARTICIPANTS, allow_blank: true
  
  validates_inclusion_of :role, in: ApplicationAuthorizer::ROLES, allow_blank: true
  validate :has_allowed_role
  validate :has_affiliation

  scope :for_group, lambda{|group| where(group: group)}
  scope :for_member, lambda{|member| where(member: member)}
  scope :affiliated_with, lambda{|group, member| for_group(group).for_member(member) }

  scope :with_role, lambda{where.not(role: nil)}
  scope :as_affiliate, lambda{where("role IS NOT NULL OR participant = ?", ApplicationAuthorizer::PARTICIPANT_MEMBER)}
  scope :as_overseer, lambda{where(role: ApplicationAuthorizer::OVERSEERS)}
  scope :as_assistant, lambda{where(role: ApplicationAuthorizer::ASSISTANTS)}
  scope :as_coach, lambda{where(role: ApplicationAuthorizer::COACHES)}

  scope :as_attendee, lambda{where.not(participant: nil)}
  scope :as_participant, lambda{ where(participant: ApplicationAuthorizer::PARTICIPANT_MEMBER)}
  scope :as_member, lambda{where(participant: ApplicationAuthorizer::PARTICIPANT_MEMBER)}
  scope :as_visitor, lambda{where(participant: ApplicationAuthorizer::PARTICIPANT_VISITOR)}

  scope :in_groups, lambda{|klass| where(group_type: klass)}
  scope :in_communities, lambda{in_groups(Community)}
  scope :in_campuses, lambda{in_groups(Campus)}
  scope :in_gatherings, lambda{in_groups(Gathering)}

  scope :for_community, lambda{|model, community| joins("JOIN #{model.to_s.tableize} ON memberships.group_id = #{model.to_s.tableize}.id").where("#{model.to_s.tableize}.community_id = ?", community)}
  scope :for_campus, lambda{|model, campus| joins("JOIN #{model.to_s.tableize} ON memberships.group_id = #{model.to_s.tableize}.id").where("#{model.to_s.tableize}.campus_id = ?", campus)}

  class << self

    def become!(group, member, role)
      m = Membership.affiliated_with(group, member).take
      if m.present?
        m.update(role: role)
      else
        m = self.create(group: group, member: member, role: role).persisted?
      end
      m
    end

    def join!(group, member, role = nil)
      m = Membership.affiliated_with(group, member).take
      if m.present?
        m.update(participant: ApplicationAuthorizer::PARTICIPANT_MEMBER, role: role || m.role)
      else
        m = self.create(group: group, member: member, participant: ApplicationAuthorizer::PARTICIPANT_MEMBER, role: role)
      end
      m
    end

  end

  ApplicationAuthorizer::ROLES.each do |role|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def become_#{role}
        self.role = "#{role}"
      end

      def become_#{role}!
        become_#{role}
        self.save
      end

      def #{role}?
        self.role == "#{role}"
      end
    METHODS
  end

  def as_affiliate?
    self.as_participant? || self.has_role?
  end

  def as_overseer?
    ApplicationAuthorizer::OVERSEERS.include?(self.role)
  end

  def as_assistant?
    ApplicationAuthorizer::ASSISTANTS.include?(self.role)
  end

  def as_coach?
    ApplicationAuthorizer::COACHES.include?(self.role)
  end

  def clear_role
    self.role = nil
  end

  def clear_role!
    clear_role
    self.save
  end

  def has_role?
    self.role.present?
  end

  def participate
    self.participant = ApplicationAuthorizer::PARTICIPANT_MEMBER
  end

  def participate!
    participate
    self.save
  end

  def end_participation!
    self.participant = nil
    self.save
  end

  def as_participant?
    self.participant == ApplicationAuthorizer::PARTICIPANT_MEMBER
  end
  alias :as_member? :as_participant?
  alias :participating? :as_participant?

  def visit
    self.participant = ApplicationAuthorizer::PARTICIPANT_VISITOR
  end

  def visit!
    visit
    self.save
  end

  def as_visitor?
    self.participant == ApplicationAuthorizer::PARTICIPANT_VISITOR
  end
  alias :visiting? :as_visitor?

  def for?(member)
    member.present? && self.member_id == member.id
  end

  def to?(group)
    group.present? && self.group_type == group.class.to_s && self.group_id == group.id
  end

  def community
    self.group.is_a?(Community) ? self.group : self.group.community if self.group.present?
  end

  protected

    def evaluate_active
      if self.role.blank? && self.participant.blank?
        self.inactive_on = DateTime.now if self.inactive_on.blank?
      else
        self.inactive_on = nil
      end
    end

    def has_affiliation
      errors.add(:base, I18n.t(:not_participant_or_role, scope: [:errors, :roles])) unless self.has_role? || self.as_participant? || self.as_visitor?
    end

    def has_allowed_role
      if self.role.present? && self.group.present? && !ApplicationAuthorizer::roles_for(self.group).include?(self.role)
        group = self.group.class.to_s.humanize.pluralize
        role = self.role.humanize
        self.errors.add(:role, I18n.t(:disallowed_role, scope: [:errors, :membership], group: group, role: role))
      end
    end

    def normalize_role
      self.role = self.role.to_s.downcase unless self.role.blank?
    end

end
