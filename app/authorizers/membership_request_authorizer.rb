class MembershipRequestAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_self?(member) ||
    acts_as_campus_leader? ||
    acts_as_gathering_member?
  end

  def readable_by?(member, options = {})
    super
    for_self?(member) ||
    acts_as_campus_leader? ||
    acts_as_gathering_member?
  end

  def updatable_by?(member, options = {})
    super
    (for_self?(member) && resource.incomplete?) ||
    acts_as_campus_leader? ||
    acts_as_gathering_leader?
  end

  def deletable_by?(member, options = {})
    super
    (for_self?(member) && resource.incomplete?) ||
    acts_as_campus_leader? ||
    acts_as_gathering_leader?
  end

  protected

    def for_self?(member)
      resource.member_id == member.id
    end

end
