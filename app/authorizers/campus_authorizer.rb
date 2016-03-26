class CampusAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    is_community_overseer?
  end

  def readable_by?(member, options = {})
    super
    as_visitor? ||
    (as_member? && is_affiliate?) || 
    (as_overseer? && (is_overseer? || is_assistant? || is_coach?))
  end

  def updatable_by?(member, options = {})
    super
    is_overseer? || is_assistant?
  end

  def deletable_by?(member, options = {})
    super
    is_community_overseer?
  end

  protected

    def determine_memberships(member, options)
      super
      community = resource.community
      @campus_membership = member.membership_in(resource) rescue nil
      @community_membership = member.membership_in(resource.community) rescue nil if community.present?
    end

end
