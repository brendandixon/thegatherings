class RequestsController < ApplicationController

  authority_actions matches: :read, respond: :update

  before_action :set_campus
  before_action :set_community
  before_action :set_gathering
  before_action :set_request
  before_action :set_member
  before_action :set_membership
  before_action :set_request, except: COLLECTION_ACTIONS
  before_action :ensure_member
  before_action :ensure_gathering
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_group
  before_action :ensure_membership
  before_action :ensure_request, except: COLLECTION_ACTIONS
  before_action :ensure_authorized

  def index
    @requests = @group.requests.unexpired
    respond_to do |format|
      format.html { render }
      format.json { render json:@requests.as_json(deep: true) }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json:@request.as_json(deep: true) }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @request.save
        format.html {
          path = @gathering.present? ? gathering_path(@gathering) : campus_path(@campus)
          redirect_to path, notice: 'Request was successfully created.'
        }
        format.json { render json:@request.as_json(deep: true) }
      else
        format.html { render :new }
        format.json { render json:{errors: @request.errors}.as_json, status: :bad_request }
      end
    end
  end

  def update
    @request.attributes = request_params[:request]
    ensure_authorized
    respond_to do |format|
      @request.answered_on = nil if @request.for_member?(current_member)
      if @request.save
        format.html { redirect_to gathering_path(@gathering), notice: 'Inquiry was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to @request.for_member?(current_member) ? gathering_path(@gathering) : gathering_requests_path(@gathering), notice: 'Request was successfully destroyed.' }
    end
  end

  def matches
    matches = RequestMatch.matches_for(@request)
    respond_to do |format|
      format.json { render json: matches.as_json }
    end
  end

  def respond
    @request.respond!(status_param)
    respond_to do |format|
      format.html { render @request }
      format.json { render json: (@request.valid? ? @request : @request.errors).as_json }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @group : @request
      perspective = is_collection_action? ? :as_leader : :as_member
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering, perspective: perspective
    end

    def ensure_campus
      @campus ||= @request.campus if @request.present?
      @campus ||= @gathering.campus if @gathering.present?
      @campus ||= @member.default_campus
    end

    def ensure_community
      @community ||= @request.community if @request.present?
      @community ||= @gathering.community if @gathering.present?
      @community ||= @campus.community if @campus.present?
      @community ||= @member.default_community
    end

    def ensure_gathering
      @gathering ||= @request.gathering if @request.present?
    end

    def ensure_group
      @group = @gathering || @campus || @community
    end

    def ensure_member
      @member ||= current_member
    end

    def ensure_membership
      @membership ||= @request.membership if @request.present?
      @membership ||= @member.memberships.for_campus(@campus).take if @campus.present?
    end

    def ensure_request
      @request ||= Request.new(params[:request])
      @request.community ||= @community
      @request.campus ||= @campus
      @request.gathering ||= @gathering
      @request.membership ||= @membership
    end

    def status_param
      status = params[:status]
      status = nil unless Request::STATUSES.include?(status)
      status
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

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

    def set_membership
      @membership = Membership.find(params[:membership_id]) rescue nil if params[:membership_id].present?
    end

    def set_request
      @request = Request.find(params[:id]) rescue nil if params[:id].present?
      @request ||= Request.find(params[:request_id]) rescue nil if params[:request_id].present?
    end

    def request_params
      params.permit(:campus_id, :community_id, :format, :gathering_id, :member_id, :membership_id, :status, :request_id, request: Request::FORM_FIELDS)
    end
end
