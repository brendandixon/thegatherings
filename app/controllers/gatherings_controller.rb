# == Schema Information
#
# Table name: gatherings
#
#  id               :integer          not null, primary key
#  community_id     :integer          not null
#  name             :string(255)
#  description      :text(65535)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  time_zone        :string(255)
#  meeting_starts   :datetime
#  meeting_ends     :datetime
#  meeting_day      :integer
#  meeting_time     :integer
#  meeting_duration :integer
#  childcare        :boolean          default(FALSE), not null
#  childfriendly    :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  minimum          :integer
#  maximum          :integer
#  open             :boolean          default(TRUE), not null
#  campus_id        :integer
#

class GatheringsController < ApplicationController
  include QueryHelpers

  COLLECTION_ACTIONS = COLLECTION_ACTIONS + %w(search)

  authority_actions gather: :read, search: :read

  before_action :set_gathering, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    scope = current_member.member_of?(@community) ? :as_member : :as_anyone
    authorize_action_for @community, scope: scope
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
        Membership.join!(@gathering, current_member, 'leader')
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

  def gather
    redirect_to member_root_path unless @gathering.persisted?

    @meeting_datetime = Timeliness.parse(params[:on], :date, format: "yyyy-mm-dd") if params[:on].present?
    @meeting_datetime ||= DateTime.now
    @meeting_datetime = @gathering.prior_meeting(@meeting_datetime.end_of_day)
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
      resource = is_collection_action? ? @community : @gathering
      scope = is_scoped_action? ? :as_anyone : :as_member
      authorize_action_for resource, community: @community, campus: @campus, scope: scope
    end

    def ensure_campus
      @campus = @gathering.campus if @gathering.present?
    end

    def ensure_community
      @community ||= @gathering.community if @gathering.present?
      if @community.blank?
        @community = current_member.communities.first
        redirect_to (@community.present? ? community_gatherings_path(@community) : member_root_path)
      end
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      @gathering.community ||= @community if @gathering.present?
    end

    def set_gathering
      @gathering = Gathering.find(params[:id]) rescue nil
      @gathering ||= Gathering.new(gathering_params[:gathering])
    end

    def gathering_params
      params.permit(gathering: [:name, :description, *Gathering.address_fields, :meeting_starts, :meeting_ends, :meeting_day, :meeting_time, :meeting_duration])
    end

end
