class RoleContext

  LEADER = "leader"
  ASSISTANT = "assistant"
  OVERSEER = "overseer"
  MEMBER = "member"
  VISITOR = "visitor"

  ROLES = [LEADER, ASSISTANT, OVERSEER, MEMBER, VISITOR]
  ASSISTANTS = [ASSISTANT]
  LEADERS = [LEADER, ASSISTANT]
  OVERSEERS = LEADERS + [OVERSEER]
  MEMBERS = OVERSEERS + [MEMBER]
  PARTICIPANTS = MEMBERS + [VISITOR]
  VISITORS = [VISITOR]

  COMMUNITY_ROLES = LEADERS + [MEMBER]
  CAMPUS_ROLES = MEMBERS
  GATHERING_ROLES = ROLES - [OVERSEER]

  class<<self

    def context_for(member, community: nil, campus: nil, gathering: nil)
      RoleContext.new(member, community, campus, gathering)
    end

    def roles_allowed_for(group)
      case group
      when Community then COMMUNITY_ROLES
      when Campus then CAMPUS_ROLES
      when Gathering then GATHERING_ROLES
      else
        []
      end
    end

    def is_role_allowed?(group, role)
      roles_allowed_for(group).include?(role)
    end

  end

  def campus
    @campus
  end

  def community
    @community
  end

  def gathering
    @gathering
  end

  def member
    @member
  end

  def acts_as_community_leader?
    is_community_leader?
  end

  def acts_as_community_member?
    is_community_member? || acts_as_community_leader?
  end

  def acts_as_campus_leader?
    is_campus_leader? || acts_as_community_leader?
  end

  def acts_as_campus_member?
    is_campus_member? || acts_as_community_member?
  end

  def acts_as_campus_overseer?
    is_campus_overseer? || acts_as_campus_leader?
  end

  def acts_as_gathering_leader?
    is_gathering_leader? || is_assigned_overseer? || acts_as_campus_leader?
  end

  def acts_as_gathering_member?
    is_gathering_member? || is_assigned_overseer?
  end

  def acts_as_gathering_visitor?
    @gathering_membership.present?
  end

  def dump_roles
    return unless Rails.env.development? || Rails.env.test?
    
    roles = []

    COMMUNITY_ROLES.each {|role| roles << "Community #{role.to_s.humanize}? #{self.send("is_community_#{role}?".to_sym)}"}
    CAMPUS_ROLES.each {|role| roles << "Campus #{role.to_s.humanize}? #{self.send("is_campus_#{role}?".to_sym)}"}
    GATHERING_ROLES.each {|role| roles << "Gathering #{role.to_s.humanize}? #{self.send("is_gathering_#{role}?".to_sym)}"}
    roles << "Is Assigned Overseer? #{is_assigned_overseer?}"
    roles << "Acts as Community Leader? #{acts_as_community_leader?}"
    roles << "Acts as Community Member? #{acts_as_community_member?}"
    roles << "Acts as Campus Leader? #{acts_as_campus_leader?}"
    roles << "Acts as Campus Member? #{acts_as_campus_member?}"
    roles << "Acts as Campus Overseer? #{acts_as_campus_overseer?}"
    roles << "Acts as Gathering Leader? #{acts_as_gathering_leader?}"
    roles << "Acts as Gathering Member? #{acts_as_gathering_member?}"
    roles << "Acts as Gathering Visitor? #{acts_as_gathering_visitor?}"
    roles
  end

  protected

    def initialize(member, community, campus, gathering)
      @member = member
      @community = community
      @campus = campus
      @gathering = gathering

      @community_membership = member.active_member_of?(@community)
      @campus_membership = member.active_member_of?(@campus)
      @gathering_membership = member.active_member_of?(@gathering)
      @is_assigned_overseer = @gathering.present? && @gathering.is_active_overseer?(@member)
    end

    COMMUNITY_ROLES.each do |role|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def is_community_#{role}?
          @community_membership.present? && @community_membership.as_#{role}?
        end
      METHODS
    end

    CAMPUS_ROLES.each do |role|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def is_campus_#{role}?
          @campus_membership.present? && @campus_membership.as_#{role}?
        end
      METHODS
    end

    GATHERING_ROLES.each do |role|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def is_gathering_#{role}?
          @gathering_membership.present? && @gathering_membership.as_#{role}?
        end
      METHODS
    end

    def is_assigned_overseer?
      @is_assigned_overseer
    end

end
