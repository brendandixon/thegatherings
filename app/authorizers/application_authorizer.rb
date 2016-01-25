class ApplicationAuthorizer < Authority::Authorizer

  ROLES = %w(administrator leader coach assistant)
  OVERSEERS = ROLES - %w(coach)

  COMMUNITY_ROLES = ROLES
  CAMPUS_ROLES    = ROLES
  GATHERING_ROLES = ROLES - %w(administrator)

  SCOPES = [:as_anyone, :as_member, :as_leader, :as_visitor]

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
      options[:scope] = :as_member unless SCOPES.include?(options[:scope])
      @scope = options[:scope]
    end

    %w(community campus gathering).each do |group|
      %w(affiliate overseer participant visitor).each do |affliation|
        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def is_#{group}_#{affliation}?
            @#{group}_membership.present? && @#{group}_membership.as_#{affliation}?
          end
        METHODS
      end

      ROLES.each do |role|
        class_eval <<-METHODS, __FILE__, __LINE__ + 1
          def is_#{group}_#{role}?
            @#{group}_membership.present? && @#{group}_membership.#{role}?
          end
        METHODS
      end
    end

    ROLES.each do |role|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def is_#{role}?
          is_community_#{role}? || is_campus_#{role}? || is_gathering_#{role}?
        end
      METHODS
    end

    def as_anyone?
      @scope == :as_anyone
    end

    def as_leader?
      true
    end

    def as_member?
      @scope != :as_leader
    end

    def as_visitor?
      [:as_anyone, :as_visitor].include?(@scope)
    end

    def is_affiliate?
      is_community_affiliate? || is_campus_affiliate? || is_gathering_affiliate?
    end

    def is_overseer?
      is_community_overseer? || is_campus_overseer?
    end

    def is_participant?
      is_community_participant? || is_campus_participant? || is_gathering_participant?
    end

end
