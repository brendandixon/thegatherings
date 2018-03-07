class CommunityAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    for_community_resource? ? acts_as_community_leader? : false
  end

  def readable_by?(member, options = {})
    super
    as_anyone? ||
    as_visitor? ||
    for_community_resource? ||
    (as_member? && acts_as_community_member?) ||
    (as_leader? && acts_as_community_leader?)
  end

  def updatable_by?(member, options = {})
    super
    acts_as_community_leader?
  end

  def deletable_by?(member, options = {})
    super
    for_community_resource? ? acts_as_community_leader? : false
  end

  protected

    def for_community_resource?
      resource.is_a?(RoleName) || resource.is_a?(Tag) || resource.is_a?(TagSet)
    end

end
