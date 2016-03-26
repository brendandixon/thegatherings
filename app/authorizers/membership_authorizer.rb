class MembershipAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    ((to_community? || to_campus?) && (for_self?(member) || is_overseer? || is_assistant?)) ||
    (to_gathering? && (is_gathering_overseer? || is_gathering_assistant? || is_coach?))
  end

  def readable_by?(member, options = {})
    super
    for_self?(member) ||
    ((to_community? || to_campus?) && (is_overseer? || is_assistant?)) ||
    (to_gathering? && (is_gathering_participant? || is_gathering_overseer? || is_gathering_assistant? || is_coach?))
  end

  def updatable_by?(member, options = {})
    super
    ((to_community? || to_campus?) && (for_self?(member) || is_overseer? || is_assistant?)) ||
    (to_gathering? && (is_gathering_overseer? || is_gathering_assistant? || is_coach?))
  end

  def deletable_by?(member, options = {})
    super
    for_self?(member) ||
    ((to_community? || to_campus?) && (is_overseer? || is_assistant?)) ||
    (to_gathering? && (is_gathering_overseer? || is_gathering_assistant? || is_coach?))
  end

  private

    def determine_memberships(member, options = {})
      super
      community = options[:community]
      campus = options[:campus]
      gathering = options[:gathering]
      @community_membership = member.membership_in(community) rescue nil if community.present?
      @campus_membership = member.membership_in(campus) rescue nil if campus.present?
      @gathering_membership = member.membership_in(gathering) rescue nil if gathering.present?
    end

    def for_self?(member)
      resource.member_id == member.id
    end

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
