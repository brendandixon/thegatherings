class AttendanceRecordAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    is_gathering_overseer? || (is_overseer? && !is_assistant?) || is_coach?
  end

  def readable_by?(member, options = {})
    super
    is_gathering_affiliate? || (is_overseer? && !is_assistant?) || is_coach?
  end

  def updatable_by?(member, options = {})
    super
    is_gathering_overseer? || (is_overseer? && !is_assistant?) || is_coach?
  end

  def deletable_by?(member, options = {})
    super
    is_gathering_overseer? || (is_overseer? && !is_assistant?) || is_coach?
  end

  protected

    def determine_memberships(member, options = {})
      super
      gathering = resource.gathering || options[:gathering]
      community = gathering.community if gathering.present?
      campus = gathering.campus if gathering.present?
      @community_membership = member.membership_in(community) rescue nil if community.present?
      @campus_membership = member.membership_in(campus) rescue nil if campus.present?
      @gathering_membership = member.membership_in(gathering) rescue nil
    end

end
