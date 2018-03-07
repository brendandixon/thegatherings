class PreferenceAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_self?(member) ||
    (as_signup? && acts_as_campus_member?) ||
    acts_as_campus_leader?
  end

  def readable_by?(member, options = {})
    super
    for_self?(member) ||
    (as_signup? && acts_as_campus_member?) ||
    acts_as_campus_leader?
  end

  def updatable_by?(member, options = {})
    super
    for_self?(member) ||
    (as_signup? && acts_as_campus_member?) ||
    acts_as_campus_leader?
  end

  def deletable_by?(member, options = {})
    super
    for_self?(member) ||
    (as_signup? && acts_as_campus_member?) ||
    acts_as_campus_leader?
  end

  protected

    def for_self?(member)
      resource.member_id == member.id
    end

end
