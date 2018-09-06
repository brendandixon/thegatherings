class PreferenceAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_leader?
  end

  def readable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_leader?
  end

  def updatable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_leader?
  end

  def deletable_by?(member, options = {})
    super
    for_self_membership?(member) ||
    acts_as_campus_leader?
  end

end
