class GatheringAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    is_affiliate?
  end

  def readable_by?(member, options = {})
    super
    (as_anyone? && is_affiliate?) ||
    (as_member? && is_gathering_affiliate?) ||
    (as_overseer? && (is_gathering_overseer? || is_gathering_assistant?)) ||
    (as_visitor? && is_gathering_visitor?) ||
    is_overseer? ||
    is_coach?
  end

  def updatable_by?(member, options = {})
    super
    is_gathering_overseer? || is_gathering_assistant? || is_overseer? || is_coach?
  end

  def deletable_by?(member, options = {})
    super
    is_gathering_overseer? || is_gathering_assistant? || is_overseer? || is_coach?
  end

  protected

    def determine_memberships(member, options = {})
      super
      community = resource.community || options[:community]
      campus = resource.campus || options[:campus]
      gathering = resource.is_a?(Gathering) ? resource : resource.gathering
      @community_membership = member.membership_in(community) rescue nil if community.present?
      @campus_membership = member.membership_in(campus) rescue nil if campus.present?
      @gathering_membership = member.membership_in(gathering) rescue nil if gathering.present?
    end

end
