module Joinable
  extend ActiveSupport::Concern

  included do
    has_many :memberships, as: :group, dependent: :destroy
  end

  def assistants
    self.memberships.as_assistant.map{|m| m.member}
  end

  def leaders
    self.memberships.as_leader.map{|m| m.member}
  end

  def members
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::MEMBER)
    self.memberships.as_member.map{|m| m.member}
  end

  def overseers
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::OVERSEER)
    self.memberships.as_overseer.map{|m| m.member}
  end

  def participants
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::MEMBER)
    self.memberships.as_participant.map{|m| m.member}
  end

  def visitors
    return [] unless RoleContext::is_role_allowed?(self, RoleContext::VISITOR)
    self.memberships.as_visitor.map{|m| m.member}
  end

end
