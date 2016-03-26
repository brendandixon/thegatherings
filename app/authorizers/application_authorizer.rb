class ApplicationAuthorizer < Authority::Authorizer

  # Notes:
  # In addition to the ROLES and PARTICIPANTS expressly defined below, other relationships exist:
  #   Affiliate: Anyone with a valid ROLE or is a member
  #   Overseer: An Administrator or Leader

  OVERSEERS = %w(administrator leader)
  ASSISTANTS = %w(assistant)
  COACHES = %W(coach)
  ROLES = OVERSEERS + ASSISTANTS + COACHES

  COMMUNITY_ROLES = ROLES
  CAMPUS_ROLES    = ROLES
  GATHERING_ROLES = ROLES - %w(administrator)

  PARTICIPANT_MEMBER = 'member'
  PARTICIPANT_VISITOR = 'visitor'
  PARTICIPANTS = [PARTICIPANT_MEMBER, PARTICIPANT_VISITOR]

  SCOPES = [:as_anyone, :as_member, :as_overseer, :as_visitor]

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

    def roles_collection
      @@rc ||= ROLES.map{|v| [v, I18n.t(v, scope: [:tags, :roles])]} << ["", I18n.t(:none, scope: [:tags, :roles])]
    end

    def roles_for(group)
      case group
      when Community then ApplicationAuthorizer::COMMUNITY_ROLES
      when Campus then ApplicationAuthorizer::CAMPUS_ROLES
      when Gathering then ApplicationAuthorizer::CAMPUS_ROLES
      else
        []
      end
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
      # TODO: Throw a security exception if the incoming scope is present and unrecognized?
      options[:scope] = :as_member unless SCOPES.include?(options[:scope])
      @scope = options[:scope]
    end

    %w(community campus gathering).each do |group|
      (PARTICIPANTS + ROLES + %w(affiliate overseer participant)).each do |affliation|
        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def is_#{group}_#{affliation}?
            @#{group}_membership.present? && @#{group}_membership.as_#{affliation}?
          end
        METHODS
      end
    end

    def as_anyone?
      @scope == :as_anyone
    end

    def as_overseer?
      true
    end

    def as_member?
      @scope != :as_overseer
    end

    def as_visitor?
      [:as_anyone, :as_visitor].include?(@scope)
    end

    def is_administrator?
      is_community_administrator? || is_campus_administrator?
    end

    def is_affiliate?
      is_community_affiliate? || is_campus_affiliate?
    end

    def is_overseer?
      is_community_overseer? || is_campus_overseer?
    end

    def is_assistant?
      is_community_assistant? || is_campus_assistant?
    end

    def is_coach?
      is_community_coach? || is_campus_coach? || is_gathering_coach?
    end

    def is_participant?
      is_community_participant? || is_campus_participant?
    end

end
