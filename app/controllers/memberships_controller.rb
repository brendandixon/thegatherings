class MembershipsController < ApplicationController

  before_action :set_community
  before_action :set_campus
  before_action :set_gathering
  before_action :set_membership
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_gathering
  before_action :ensure_authorized

  def index
    @memberships = @group.memberships
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @membership.save
        establish_memberships
        format.html { redirect_to signup_path_for(@membership.member), notice: 'Membership was successfully created.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def update
    @membership.attributes = membership_params[:membership]
    authorize_action_for @membership, community: @community, campus: @campus, gathering: @gathering
    respond_to do |format|
      if @membership.save
        format.html { redirect_to :back, notice: 'Membership was successfully updated.'}
        # format.html { redirect_to membership_path(@membership), notice: 'Membership was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    # TODO: Change to use url_for with @group
    url = case @membership.group
          when Campus then community_campuses_path(@community)
          when Community then communities_path
          when Gathering then community_gatherings_path(@community)
          else member_root_path
          end
    # TODO: Ensure Community memberships are not deleted if Campus memberships remain
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to url, notice: 'Membership was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @group : @membership
      context = is_collection_action? || in_signup_for?(@membership.member) ? :as_member : :as_leader
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
    end

    def ensure_campus
      @campus ||= @membership.campus if @membership.present?
    end

    def ensure_community
      @community ||= @membership.community if @membership.present?
    end

    def ensure_gathering
      @gathering ||= @membership.gathering if @membership.present?
    end

    def establish_memberships
      groups =  case
                when @gathering.present? then [@community, @campus]
                when @campus.present? then [@community]
                else []
                end
      groups.each {|group| @membership.member.join!(group) if group.present?}
    end

    def set_community
      return unless params[:community_id].present?
      @community = Community.find(params[:community_id]) rescue nil
      @group = @community
    end

    def set_campus
      return unless params[:campus_id].present?
      @campus = Campus.find(params[:campus_id]) rescue nil
      @group = @campus
    end

    def set_gathering
      return unless params[:gathering_id].present?
      @gathering = Gathering.find(params[:gathering_id]) rescue nil
      @group = @gathering
    end

    def set_membership
      return if is_collection_action?
      @membership = Membership.find(params[:id]) rescue nil if params[:id].present?
      if @membership.blank?
        @membership ||= Membership.new(membership_params[:membership])
        @membership.group = @group
        @membership.member = current_member
      end
    end

    def membership_params
      params.permit(membership: Membership::FORM_FIELDS)
    end

end
