class RequestAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_overseer? ||
    acts_as_campus_member? ||
    acts_as_gathering_member?
  end

  def readable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_overseer? ||
    acts_as_gathering_leader?
  end

  def updatable_by?(member, options = {})
    super
    (for_self_membership?(member) && resource.incomplete?) ||
    acts_as_campus_overseer? ||
    acts_as_gathering_leader?
  end

  def deletable_by?(member, options = {})
    super
    (for_self_membership?(member) && resource.incomplete?) ||
    acts_as_campus_overseer? ||
    acts_as_gathering_leader?
  end

end
