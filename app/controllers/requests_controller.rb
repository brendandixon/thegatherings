class RequestsController < ApplicationController

  authority_actions accept: :update, answer: :update, dismiss: :update

  before_action :set_campus
  before_action :set_member
  before_action :set_gathering
  before_action :set_request, except: COLLECTION_ACTIONS

  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_member
  before_action :ensure_request, except: COLLECTION_ACTIONS

  before_action :ensure_authorized

  def index
    @requests = Request.for_gathering(@gathering).unexpired
  end

  def show
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
        format.json { render json:@request.as_json }
      else
        format.html { render :new }
        format.json { render json:{errors: @request.errors}.as_json, status: :bad_request }
      end
    end
  end

  def accept
    respond_to do |format|
      if @request.member.join!(@gathering).persisted?
        @request.accept!
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: 'Request accepted.' }
      else
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: 'Failed to join Gathering.' }
      end
    end
  end

  def answer
    respond_to do |format|
      if @request.answer!
        MemberMailer.answer_request(current_member, @request, params[:answer]).deliver_now
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: "Request was successfully answered." }
      else
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: "Unable to answer Request." }
      end
    end
  end

  def dismiss
    respond_to do |format|
      if @request.dismiss!
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: 'Request dismiss.' }
      else
        format.html { redirect_to gathering_requests_path(@request.gathering), notice: 'Failed to dismiss request.' }
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

  private

    def ensure_authorized
      resource = is_collection_action? ? @gathering : @request
      context = is_collection_action? ? :as_leader : :as_member
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering, context: context
    end

    def ensure_campus
      @campus = @gathering.campus if @campus.blank? && @gathering.present?
    end

    def ensure_community
      @community = @campus.community if @campus.present?
    end

    def ensure_member
      @member ||= current_member
    end

    def ensure_request
      @request ||= Request.new(params[:request])
      @request.campus ||= @campus
      @request.gathering ||= @gathering
      @request.member ||= @member
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
      logger.debug("FOUND CAMPUS #{@campus}")
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
    end

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

    def set_request
      @request = Request.find(params[:id]) if params[:id].present?
    end

    def request_params
      params.permit(:campus_id, :format, :gathering_id, :member_id, request: Request::FORM_FIELDS)
    end
end
