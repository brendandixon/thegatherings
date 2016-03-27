class MembershipRequestAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_self?(member) ||
    (for_gathering? && is_gathering_overseer? || is_gathering_assistant?) ||
    is_overseer? ||
    is_coach?
  end

  def readable_by?(member, options = {})
    super
    for_self?(member) ||
    (for_gathering? && is_gathering_overseer? || is_gathering_assistant?) ||
    is_overseer? ||
    is_coach?
  end

  def updatable_by?(member, options = {})
    super
    (for_self?(member) && !resource.completed?) ||
    (for_gathering? && is_gathering_overseer? || is_gathering_assistant?) ||
    is_overseer? ||
    is_coach?
  end

  def deletable_by?(member, options = {})
    super
    for_self?(member) ||
    (for_gathering? && is_gathering_overseer? || is_gathering_assistant?) ||
    is_overseer? ||
    is_coach?
  end

  protected

    def determine_memberships(member, options = {})
      super
      @gathering = resource.gathering || options[:gathering]
      community = @gathering.community if @gathering.present?
      campus = @gathering.campus if @gathering.present?
      @community_membership = member.membership_in(community) rescue nil if community.present?
      @campus_membership = member.membership_in(campus) rescue nil if campus.present?
      @gathering_membership = member.membership_in(@gathering) rescue nil
    end

    def for_self?(member)
      resource.member_id == member.id
    end

    def for_gathering?
      resource.gathering_id == @gathering.id
    end

end