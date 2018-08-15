class GatheringsController < ApplicationController
  include QueryHelpers

  COLLECTION_ACTIONS = COLLECTION_ACTIONS + %w(search)

  authority_actions attendees: :read, gather: :read, search: :read

  before_action :set_campus
  before_action :set_community
  before_action :set_gathering, except: COLLECTION_ACTIONS
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_gathering
  before_action :ensure_group
  before_action :ensure_authorized

  def index
    @gatherings = @group.present? ? @group.gatherings : []
    respond_to do |format|
      format.html { render }
      format.json { render json:@gatherings.as_json(deep: true) }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json:@gathering.as_json(deep: true) }
    end
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

  def attendees
    @gatherings = @gathering.present? ? [@gathering] : (@group.present? ? @group.gatherings : [])
    attendees = @gatherings.inject(0){|total, g| total += g.members.count}
    respond_to do |format|
      format.json { render json:{ attendees: attendees, average: (attendees / @gatherings.length).round }.as_json }
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

  protected

    def ensure_authorized
      # TODO: Generalize how to determine when to use leader perspective
      if self.action_name == 'attendees'
        resource = @gathering || @group
        perspective = :as_leader
      else
        resource = is_collection_action? ? @group : @gathering
        perspective = is_perspective_action? ? :as_anyone : :as_member
        
        raise Authority::SecurityViolation.new(current_member, "the #{@gathering.name} Gathering") if !is_collection_action? && @gathering.present? && !@gathering.belongs_to?(@campus)
      end

      authorize_action_for resource, community: @community, campus: @campus, perspective: perspective
    end

    def ensure_campus
      @campus ||= @gathering.campus if @gathering.present?
      @campus ||= current_member.default_campus
    end

    def ensure_community
      @community ||= @gathering.community if @gathering.present?
      @community ||= @campus.community if @campus.present?
      @community ||= current_member.default_community
    end

    def ensure_gathering
      if self.action_name != 'attendees'
        @gathering ||= Gathering.new(gathering_params[:gathering])
        @gathering.community ||= @community
        @gathering.campus ||= @campus
      end
    end

    def ensure_group
      @group = @campus || @community
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    end
    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_gathering
      @gathering = Gathering.find(params[:id]) rescue nil if params[:id].present?
      @gathering ||= Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
    end

    def gathering_params
      params.permit(:campus_id, :community_id, :format, :gathering_id, gathering: Gathering::FORM_FIELDS)
    end

end
