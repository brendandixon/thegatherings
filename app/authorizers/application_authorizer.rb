class ApplicationAuthorizer < Authority::Authorizer

  PERSPECTIVES = [:as_anyone, :as_assistant, :as_leader, :as_member, :as_signup, :as_visitor]

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

  end

  def creatable_by?(member, options = {})
    prepare(member, options)
    false
  end

  def readable_by?(member, options = {})
    prepare(member, options)
    false
  end

  def updatable_by?(member, options = {})
    prepare(member, options)
    false
  end

  def deletable_by?(member, options = {})
    prepare(member, options)
    false
  end

  protected

    def prepare(member, options = {})
      # TODO: Throw a security exception if the incoming context is present and unrecognized?
      options[:perspective] = :as_member unless PERSPECTIVES.include?(options[:perspective])
      @perspective = options[:perspective]

      options[:campus] ||= options[:gathering].campus if options[:gathering].present?
      options[:community] ||= options[:campus].community if options[:campus].present?

      @community = (options[:community] || (for_community? ? resource : resource.community)) rescue nil
      @campus = (options[:campus] || (for_campus? ? resource : resource.campus)) rescue nil
      @gathering = (options[:gathering] || (for_gathering? ? resource : resource.gathering)) rescue nil

      @role_context = RoleContext.context_for(member, community: @community, campus: @campus, gathering: @gathering)
    end

    %w(
      acts_as_community_leader?
      acts_as_community_member?
      acts_as_campus_leader?
      acts_as_campus_member?
      acts_as_campus_overseer?
      acts_as_gathering_leader?
      acts_as_gathering_member?
      acts_as_gathering_visitor?
    ).each do |query|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def #{query}
          @role_context.#{query}
        end
      METHODS
    end

    def as_anyone?
      @perspective == :as_anyone
    end

    def as_leader?
      [:as_assistant, :as_leader].include?(@perspective)
    end

    def as_overseer?
      [:as_assistant, :as_leader, :as_overseer].include?(@perspective)
    end

    def as_member?
      [:as_assistant, :as_leader, :as_overseer, :as_member].include?(@perspective)
    end

    def as_participant?
      [:as_assistant, :as_leader, :as_overseer, :as_member, :as_visitor].include?(@perspective)
    end

    def as_signup?
      [:as_signup].include?(@perspective)
    end

    def as_visitor?
      [:as_visitor].include?(@perspective)
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

    def for_self?(member)
      resource.member_id == member.id
    end

    def for_self_membership?(member)
      resource.membership.member_id == member.id
    end

end
