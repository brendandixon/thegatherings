class CampusAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    acts_as_community_leader?
  end

  def readable_by?(member, options = {})
    super
    as_anyone? ||
    as_visitor? ||
    (as_member? && acts_as_campus_member?) ||
    (as_leader? && acts_as_campus_leader?)
  end

  def updatable_by?(member, options = {})
    super
    acts_as_campus_leader?
  end

  def deletable_by?(member, options = {})
    super
    acts_as_community_leader?
  end

end
