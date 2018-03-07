class GatheringsController < ApplicationController
  include QueryHelpers

  COLLECTION_ACTIONS = COLLECTION_ACTIONS + %w(search)

  authority_actions gather: :read, search: :read

  before_action :set_campus
  before_action :set_community
  before_action :set_gathering, except: COLLECTION_ACTIONS
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_gathering
  before_action :ensure_authorized

  def index
    context = current_member.member_of?(@community) ? :as_member : :as_anyone
    authorize_action_for @community, context: context
    @gatherings = @community.gatherings.is_open
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @gathering.save
        format.html { redirect_to edit_gathering_tags_path(@gathering), notice: 'Gathering was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @gathering.attributes = gathering_params[:gathering]
    ensure_authorized
    respond_to do |format|
      if @gathering.save
        format.html { redirect_to edit_gathering_tags_path(@gathering), notice: 'Gathering was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @gathering.destroy
    respond_to do |format|
      format.html { redirect_to community_gatherings_path(@community), notice: 'Gathering was successfully destroyed.' }
    end
  end

  def search
    @gatherings = Gathering
    
    @gatherings = @gatherings.for_community(@community) unless @community.blank?
    @gatherings = @gatherings.for_campuses(params[:campuses]) if params[:campuses].present?
    @gatherings = @gatherings.is_childfriendly(to_bool(params[:childfriendly])) if params[:childfriendly].present?
    @gatherings = params[:open].present? ? @gatherings.is_open(to_bool(params[:open])) : @gatherings.is_open

    days = to_days(params[:day]) if params[:day].present?
    @gatherings = @gatherings.meets_on(*days) if days.present?

    times = params[:time].split(',') if params[:time].present?
    if times.present?
      times = times.map{|t| to_time_range(t)}
      if times.present?
        s = times.length > 1 ? "(" : ""
        r = times.shift
        s += "gatherings.meeting_time between '#{r.begin}' and '#{r.end}'"
        times.each {|tr| s += " OR gatherings.meeting_time between '#{tr.begin}' and '#{tr.end}'"}
        s += ")" if times.length >= 1
        @gatherings = @gatherings.where(s) if times.length >= 1
      end
    end
    
    @gatherings = Taggable.scope_to_tags(@gatherings, params)
    render :index
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @campus : @gathering
      context = is_contextual_action? ? :as_anyone : :as_member
      authorize_action_for resource, community: @community, campus: @campus, context: context
    end

    def ensure_campus
      @campus = @gathering.campus if @campus.blank? && @gathering.present?
      @campus = current_member.active_campuses.first.group if @campus.blank? && current_member.active_campuses.present?
      redirect_to member_root_path if @campus.blank?
    end

    def ensure_community
      @community = @campus.community if @community.blank? || @community != @campus.community
    end

    def ensure_gathering
      if @gathering.blank?
        @gathering = Gathering.new(gathering_params[:gathering])
        @gathering.community = @community
        @gathering.campus = @campus
      end
      redirect_to member_root_path unless @gathering.campus = @campus
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    end
    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_gathering
      @gathering = Gathering.find(params[:id]) rescue nil if params[:id].present?
    end

    def gathering_params
      params.permit(:campus_id, :community_id, gathering: Gathering::FORM_FIELDS)
    end

end
