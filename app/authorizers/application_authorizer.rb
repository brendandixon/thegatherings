class ApplicationAuthorizer < Authority::Authorizer

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

  CONTEXTS = [:as_anyone, :as_assistant, :as_leader, :as_member, :as_signup, :as_visitor]

  class <<self

    # Any class method from Authority::Authorizer that isn't overridden
    # will call its authorizer's default method.
    #
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def default(adjective, user)
      # 'Whitelist' strategy for security: anything not explicitly allowed is
      # considered forbidden.
      false
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

  def creatable_by?(member, options = {})
    determine_memberships(member, options)
    false
  end

  def readable_by?(member, options = {})
    determine_memberships(member, options)
    false
  end

  def updatable_by?(member, options = {})
    determine_memberships(member, options)
    false
  end

  def deletable_by?(member, options = {})
    determine_memberships(member, options)
    false
  end

  protected

    def determine_memberships(member, options = {})
      # TODO: Throw a security exception if the incoming context is present and unrecognized?
      options[:context] = :as_member unless CONTEXTS.include?(options[:context])
      @context = options[:context]

      options[:campus] ||= options[:gathering].campus if options[:gathering].present?
      options[:community] ||= options[:campus].community if options[:campus].present?

      @community_membership = community_membership_for(member, options)
      @campus_membership = campus_membership_for(member, options)
      @gathering_membership = gathering_membership_for(member, options)
      @gathering_overseer = gathering_overseer_for(member, options)

      # dump_roles_for(member)
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
      @gathering_overseer.present?
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

    def as_anyone?
      @context == :as_anyone
    end

    def as_leader?
      [:as_assistant, :as_leader].include?(@context)
    end

    def as_overseer?
      [:as_assistant, :as_leader, :as_overseer].include?(@context)
    end

    def as_member?
      [:as_assistant, :as_leader, :as_overseer, :as_member].include?(@context)
    end

    def as_participant?
      [:as_assistant, :as_leader, :as_overseer, :as_member, :as_visitor].include?(@context)
    end

    def as_signup?
      [:as_signup].include?(@context)
    end

    def as_visitor?
      [:as_visitor].include?(@context)
    end

    def community_membership_for(member, options)
      @community = options[:community] || (for_community? ? resource : resource.community)
      @community.present? ? member.active_member_of?(@community) : nil
    rescue
      nil
    end

    def campus_membership_for(member, options)
      @campus = options[:campus] || (for_campus? ? resource : resource.campus)
      @campus.present? ? member.active_member_of?(@campus) : nil
    rescue
      nil
    end

    def gathering_membership_for(member, options)
      @gathering = options[:gathering] || (for_gathering? ? resource : resource.gathering)
      @gathering.present? ? member.active_member_of?(@gathering) : nil
    rescue
      nil
    end

    def gathering_overseer_for(member, options)
      @gathering.present? ? @gathering.assigned_overseers.for_active_member(member).take : nil
    rescue
      nil
    end

    def for_community?
      resource.is_a?(Community)
    end

    def for_campus?
      resource.is_a?(Campus)
    end

    def for_gathering?
      resource.is_a?(Gathering)
    end

    protected

      def dump_roles_for(member)
        return unless Rails.env.development? || Rails.env.test?
        
        puts "Roles for #{member} #{'=' * 50}"
        COMMUNITY_ROLES.each {|role| puts "Community #{role.to_s.humanize}? #{self.send("is_community_#{role}?".to_sym)}"}
        CAMPUS_ROLES.each {|role| puts "Campus #{role.to_s.humanize}? #{self.send("is_campus_#{role}?".to_sym)}"}
        GATHERING_ROLES.each {|role| puts "Gathering #{role.to_s.humanize}? #{self.send("is_gathering_#{role}?".to_sym)}"}
        puts "Is Assigned Overseer? #{is_assigned_overseer?}"
        puts "Acts as Community Leader? #{acts_as_community_leader?}"
        puts "Acts as Community Member? #{acts_as_community_member?}"
        puts "Acts as Campus Leader? #{acts_as_campus_leader?}"
        puts "Acts as Campus Member? #{acts_as_campus_member?}"
        puts "Acts as Campus Overseer? #{acts_as_campus_overseer?}"
        puts "Acts as Gathering Leader? #{acts_as_gathering_leader?}"
        puts "Acts as Gathering Member? #{acts_as_gathering_member?}"
        puts "Acts as Gathering Visitor? #{acts_as_gathering_visitor?}"
      end

end
