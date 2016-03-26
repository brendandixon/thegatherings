module Joinable
  extend ActiveSupport::Concern

  included do
    has_many :memberships, as: :group, dependent: :destroy
  end

  def affiliates
    self.memberships.as_affiliate.map{|m| m.member}
  end

  def overseers
    self.memberships.as_overseer.map{|m| m.member}
  end

  def assistants
    self.memberships.as_assistant.map{|m| m.member}
  end

  def coaches
    self.memberships.as_coach.map{|m| m.member}
  end

  def participants
    self.memberships.as_participant.map{|m| m.member}
  end
  alias :members :participants

  def visitors
    self.memberships.as_visitor.map{|m| m.member}
  end

end
