class GatheringAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    acts_as_campus_overseer?
  end

  def readable_by?(member, options = {})
    super
    as_anyone? ||
    (as_visitor? && (acts_as_gathering_member? || acts_as_gathering_visitor?)) ||
    (as_member? && acts_as_gathering_member?) ||
    (as_leader? && acts_as_gathering_leader?)
  end

  def updatable_by?(member, options = {})
    super
    acts_as_gathering_leader?
  end

  def deletable_by?(member, options = {})
    super
    acts_as_campus_overseer?
  end

end
