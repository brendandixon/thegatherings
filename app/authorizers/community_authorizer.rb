class CommunityAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
  end

  def readable_by?(member, options = {})
    super
    as_visitor? ||
    (as_member? && is_community_affiliate?) || 
    (as_overseer? && (is_community_overseer? || is_community_assistant?))
  end

  def updatable_by?(member, options = {})
    super
    is_community_overseer? || is_community_assistant?
  end

  def deletable_by?(member, options = {})
    super
  end

  protected

    def determine_memberships(member, options)
      super
      @community_membership = member.membership_in(resource) rescue nil
    end

end
