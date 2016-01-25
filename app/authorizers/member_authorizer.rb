class MemberAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    is_overseer? || is_coach?
  end

  def readable_by?(member, options = {})
    super
    is_self?(member) || is_overseer? || is_coach? || (is_affiliate? && as_visitor?)
  end

  def updatable_by?(member, options = {})
    super
    is_self?(member) || is_overseer? || is_coach?
  end

  def deletable_by?(member, options = {})
    super
    is_self?(member) || is_overseer? || is_coach?
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

    def is_affiliate?
      (belongs_to_community? || belongs_to_campus?) && super
    end

    def is_coach?
      (belongs_to_community? || belongs_to_campus?) && super
    end

    def is_overseer?
      (belongs_to_community? || belongs_to_campus?) && super
    end

    def is_self?(member)
      member.id == resource.id
    end

end
