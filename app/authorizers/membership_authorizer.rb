class MembershipAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    (to_community? &&
      ((for_self?(member) && resource.as_member?) ||
        acts_as_community_leader?)) ||
    (to_campus? &&
      ((for_self?(member) && resource.as_member?) ||
        acts_as_campus_leader?)) ||
    (to_gathering? && acts_as_gathering_leader?)
  end

  def readable_by?(member, options = {})
    super
    for_self?(member) ||
    (to_community? && acts_as_community_member?) ||
    (to_campus? && acts_as_campus_member?) ||
    (to_gathering? && (acts_as_gathering_member? || acts_as_campus_leader?))
  end

  def updatable_by?(member, options = {})
    super
    for_self?(member) ||
    (to_community? && acts_as_community_leader?) ||
    (to_campus? && acts_as_campus_leader?) ||
    (to_gathering? && acts_as_gathering_leader?)
  end

  def deletable_by?(member, options = {})
    super
    for_self?(member) ||
    (to_community? && acts_as_community_leader?) ||
    (to_campus? && acts_as_campus_leader?) ||
    (to_gathering? && acts_as_gathering_leader?)
  end

  protected

    def to_community?
      resource.group.is_a?(Community)
    end

    def to_campus?
      resource.group.is_a?(Campus)
    end

    def to_gathering?
      resource.group.is_a?(Gathering)
    end

end
