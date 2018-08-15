class DashboardController < ApplicationController

  CAMPUS_ACTIONS = %w(gatherings)

  before_action :set_campus
  before_action :set_community
  before_action :set_gathering
  before_action :set_tab
  before_action :ensure_community
  before_action :ensure_group
  before_action :ensure_mode
  before_action :ensure_role_context
  before_action :ensure_authorized

  helper_method :acts_as_community_leader?,
    :acts_as_community_member?,
    :acts_as_campus_leader?,
    :acts_as_campus_member?,
    :acts_as_campus_overseer?

  def show
  end

  def campuses
    respond_to do |format|
      format.json { render json:@mode.campuses.as_json }
    end
  end

  def gatherings
    respond_to do |format|
      format.json { render json:@mode.gatherings(@campus).as_json }
    end
  end

  %w(
    acts_as_community_leader?
    acts_as_community_member?
    acts_as_campus_leader?
    acts_as_campus_member?
    acts_as_campus_overseer?
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
  
  def routes
    {
      admin_mode_path: @mode.is_allowed?(@campus, :admin) ? helpers.dashboard_path(community_id: @community.id, mode: :admin) : nil,
      gathering_mode_path: @mode.is_allowed?(@campus, :gathering) ? helpers.dashboard_path(community_id: @community.id, mode: :gathering) : nil,
      member_mode_path: helpers.dashboard_path(community_id: @community.id),
      campuses_path: helpers.campuses_dashboard_path(community_id: @community.id, mode: @mode.to_s),
      gatherings_path: helpers.gatherings_dashboard_path(community_id: @community.id, mode: @mode.to_s),
      logo_path: helpers.asset_path('logo-white.svg'),
      reports_path: helpers.reports_path,
      signup_path: helpers.signup_path
    }
  end

  protected

    def ensure_authorized
      return if @mode.is_allowed?
      redirect_to dashboard_path(mode: :member)
    end

    def ensure_community
      @community ||= current_member.default_community
    end

    def ensure_group
      @group = @gathering || @campus || @community
    end

    def ensure_mode
      @mode = Mode.new(current_member, @community, params[:mode])
    end

    def ensure_role_context
      @role_context = RoleContext.context_for(current_member, community: @community, campus: @campus)
    end

    def in_admin_mode?
      @mode.in_admin_mode?
    end

    def in_gathering_mode?
      @mode.in_gathering_mode?
    end

    def in_member_mode?
      @mode.in_member_mode?
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

    def set_tab
      @tab = params[:tab] || nil
    end

    def dashboard_params
      params.permit(:campus_id, :community_id, :gathering_id, :mode, :tab)
    end

end
