module Dashboard
  class DashboardController < ApplicationController

    layout 'dashboard'
    
    authority_actions health: :update, member: :read, overview: :update, reports: :update

    ROLES = [:leader, :overseer, :member]

    before_action :set_community
    before_action :set_campus
    before_action :set_gathering
    before_action :ensure_community
    before_action :ensure_campus
    before_action :ensure_group
    before_action :ensure_role_context
    before_action :ensure_authorized

    helper_method :for_campus?,
      :for_community?,
      :for_gathering?

    helper_method :acts_as_community_leader?,
      :acts_as_community_member?,
      :acts_as_campus_leader?,
      :acts_as_campus_member?,
      :acts_as_campus_overseer?,
      :acts_as_gathering_leader?,
      :acts_as_gathering_member?,
      :acts_as_gathering_visitor?

    def show
    end

    %w(campus community gathering).each do |group|
      class_eval <<-METHODS, __FILE__, __LINE__ + 1
        def for_#{group}?
          @#{group}.present? && @group == @#{group}
        end
      METHODS
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

    def dump_roles
      @role_context.dump_roles
    end

    protected

      def ensure_authorized
        raise Authority::SecurityViolation.new(current_member, "the Dashboard", @group) unless self.acts_as_campus_overseer?
        # resource = is_collection_action? ? @campus : @gathering
        # perspective = is_perspective_action? ? :as_anyone : :as_member
        # authorize_action_for resource, community: @community, campus: @campus, perspective: perspective
        authorize_action_for @group, community: @community, campus: @campus, gathering: @gathering
      end

      def ensure_campus
        @campus ||= @gathering.campus if @gathering.present?
        @campus ||= current_member.default_campus(@community)
      end

      def ensure_community
        @community ||= @group.community if @group.present?
        @community ||= current_member.default_community
      end

      def ensure_group
        @group = @gathering || @campus || @community
      end

      def ensure_role_context
        @group ||= @gathering || @campus || @community
        @role_context = RoleContext.context_for(current_member, community: @community, campus: @campus, gathering: @gathering)
      end

      def set_campus
        @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
      end

      def set_community
        @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      end

      def set_gathering
        @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
      end

      def dashboard_params
        params.permit(:campus_id, :community_id, :gathering_id)
      end

  end
end
