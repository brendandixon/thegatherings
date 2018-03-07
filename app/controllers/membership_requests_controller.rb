class MembershipRequestsController < ApplicationController

  authority_actions accept: :update, answer: :update, dismiss: :update

  before_action :set_membership_request, except: COLLECTION_ACTIONS
  before_action :set_gathering
  before_action :ensure_gathering
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_member
  before_action :ensure_authorized

  def index
    @membership_requests = MembershipRequest.for_gathering(@gathering).unexpired
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @membership_request.save
        format.html { redirect_to gathering_path(@gathering), notice: 'Request was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def accept
    respond_to do |format|
      if @membership_request.member.join!(@gathering).persisted?
        @membership_request.accept!
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: 'Request accepted.' }
      else
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: 'Failed to join Gathering.' }
      end
    end
  end

  def answer
    respond_to do |format|
      if @membership_request.answer!
        MemberMailer.answer_membership_request(current_member, @membership_request, params[:answer]).deliver_now
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: "Request was successfully answered." }
      else
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: "Unable to answer Request." }
      end
    end
  end

  def dismiss
    respond_to do |format|
      if @membership_request.dismiss!
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: 'Request dismiss.' }
      else
        format.html { redirect_to gathering_membership_requests_path(@membership_request.gathering), notice: 'Failed to dismiss request.' }
      end
    end
  end

  def update
    @membership_request.attributes = membership_request_params[:membership_request]
    ensure_authorized
    respond_to do |format|
      @membership_request.answered_on = nil if @membership_request.for_member?(current_member)
      if @membership_request.save
        format.html { redirect_to gathering_path(@gathering), notice: 'Inquiry was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @membership_request.destroy
    respond_to do |format|
      format.html { redirect_to @membership_request.for_member?(current_member) ? gathering_path(@gathering) : gathering_membership_requests_path(@gathering), notice: 'Request was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @gathering : @membership_request
      context = is_collection_action? ? :as_leader : :as_member
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering, context: context
    end

    def ensure_campus
      @campus = @gathering.campus if @gathering.present?
    end

    def ensure_community
      @community = @campus.community if @campus.present?
    end

    def ensure_gathering
      if is_collection_action?
        redirect_to member_root_path if @gathering.blank?
      else
        @gathering ||= @membership_request.gathering
        redirect_to member_root_path if @gathering.blank? || (@membership_request.persisted? && @membership_request.gathering != @gathering)
      end
    end

    def ensure_member
      if !is_collection_action?
        @membership_request.member ||= current_member unless @membership_request.persisted?
        @member = @membership_request.member
        redirect_to member_root_path if @member.blank? || (@membership_request.persisted? && @membership_request.member != @member)
      end
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
      @membership_request.gathering ||= @gathering unless is_collection_action?
    end

    def set_membership_request
      @membership_request = MembershipRequest.find(params[:id]) if params[:id].present?
      @membership_request ||= MembershipRequest.new(membership_request_params[:membership_request])
    end

    def membership_request_params
      params.permit(membership_request: MembershipRequest::FORM_FIELDS)
    end
end
