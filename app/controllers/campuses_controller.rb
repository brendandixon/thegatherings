class CampusesController < ApplicationController
  include Attendees
  include Health

  before_action :set_campus, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_campus, except: COLLECTION_ACTIONS
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    @campuses = @community.campuses
    respond_to do |format|
      format.html { render }
      format.json { render json: @campuses.as_json(deep: true) }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @campus.as_json(deep: true) }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @campus.save
        format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @campus.attributes = campus_params[:campus]
    ensure_authorized
    respond_to do |format|
      if @campus.save
        format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @campus.destroy
    respond_to do |format|
      format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @community : @campus
      perspective = is_perspective_action? ? :as_anyone : :as_member
      authorize_action_for resource, community: @community, perspective: perspective
    end

    def ensure_campus
      @campus ||= Campus.new(campus_params[:campus]) if params[:campus].present?
      @campus ||= current_member.default_campus
      @campus.community ||= current_member.default_community
    end

    def ensure_community
      @community ||= @campus.community if @campus.present?
      @community ||= current_member.default_community
    end

    def set_campus
      @campus ||= Campus.find(params[:id]) rescue nil if params[:id].present?
      @campus ||= Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def campus_params
      params.permit(:campus_is, :community_id, :format, campus: Campus::FORM_FIELDS)
    end
end
