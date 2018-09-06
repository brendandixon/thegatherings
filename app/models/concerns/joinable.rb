module Joinable
  extend ActiveSupport::Concern

  included do
    has_many :memberships, as: :group, dependent: :destroy

    if self < ApplicationRecord
      scope :for_member, lambda{|member| joins(:memberships).where('memberships.member_id = ?', member)}
    end

  end

  def active_leaders(dt = DateTime.current)
    self.memberships.active_on(dt).as_leader
  end

  def is_active_leader?(member, dt = DateTime.current)
    self.active_leaders(dt).for_member(member).exists?
  end

  def active_members(dt = DateTime.current)
    self.memberships.active_on(dt)
  end

  def is_active_member?(member, dt = DateTime.current)
    self.active_members.for_member(member).exists?
  end

  def active_overseers(dt = DateTime.current)
    self.memberships.active_on(dt).as_overseer
  end

  def is_active_overseer?(member, dt = DateTime.current)
    self.active_overseers(dt).for_member(member).exists?
  end

  def assistants
    self.memberships.as_assistant.to_a
  end

  def leaders
    self.memberships.as_leader.to_a
  end

  def members
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::MEMBER)
    self.memberships.as_member.to_a
  end

  def overseers
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::OVERSEER)
    self.memberships.as_overseer.to_a
  end

  def participants
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::MEMBER)
    self.memberships.as_participant.to_a
  end

  def visitors
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::VISITOR)
    self.memberships.as_visitor.to_a
  end

  def all_leaders
    self.leaders + self.assistants + self.overseers
  end

  def all_members
    self.all_leaders + self.members
  end

  def all_participants
    self.all_members + self.participants
  end

end
