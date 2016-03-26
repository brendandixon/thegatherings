class MemberAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    (belongs_to_community? || belongs_to_campus?) && (is_overseer? || is_assistant? || is_coach?)
  end

  def readable_by?(member, options = {})
    super
    is_self?(member) ||
    (as_visitor? && ((belongs_to_community? || belongs_to_campus?) && is_affiliate?)) ||
    ((belongs_to_community? || belongs_to_campus?) && (is_overseer? || is_assistant? || is_coach?))
  end

  def updatable_by?(member, options = {})
    super
    is_self?(member) ||
    ((belongs_to_community? || belongs_to_campus?) && (is_overseer? || is_assistant? || is_coach?))
  end

  def deletable_by?(member, options = {})
    super
    is_self?(member) ||
    ((belongs_to_community? || belongs_to_campus?) && (is_overseer? || is_assistant? || is_coach?))
  end

  protected

    def belongs_to_community?
      (!resource.persisted? || (@community.present? && resource.membership_in(@community).present?))
    end

    def belongs_to_campus?
      (!resource.persisted? || (@campus.present? && resource.membership_in(@campus).present?))
    end

    def determine_memberships(member, options = {})
      super
      @community = options[:community]
      @campus = options[:campus]
      @community_membership = member.membership_in(@community) rescue nil if @community.present?
      @campus_membership = member.membership_in(@campus) rescue nil if @campus.present?
    end

    def is_self?(member)
      member.id == resource.id
    end

end
