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
    return [] unless ApplicationAuthorizer::is_role_allowed?(self, ApplicationAuthorizer::MEMBER)
    self.memberships.as_member.map{|m| m.member}
  end

  def overseers
    return [] unless ApplicationAuthorizer::is_role_allowed?(self, ApplicationAuthorizer::OVERSEER)
    self.memberships.as_overseer.map{|m| m.member}
  end

  def participants
    return [] unless ApplicationAuthorizer::is_role_allowed?(self, ApplicationAuthorizer::MEMBER)
    self.memberships.as_participant.map{|m| m.member}
  end

  def visitors
    return [] unless ApplicationAuthorizer::is_role_allowed?(self, ApplicationAuthorizer::VISITOR)
    self.memberships.as_visitor.map{|m| m.member}
  end

end
