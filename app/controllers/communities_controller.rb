class CommunitiesController < ApplicationController

  before_action :set_community, except: COLLECTION_ACTIONS
  before_action :ensure_authorized

  def index
    @communities = Community.all
    respond_to do |format|
      format.html { render }
      format.json { render json: @communities.as_json }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @community.as_json }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @community.save
        format.html { redirect_to communities_path, notice: 'Community was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @community.attributes = community_params[:community]
    ensure_authorized
    respond_to do |format|
      if @community.save
        format.html { redirect_to communities_path, notice: 'Community was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @community.destroy
    respond_to do |format|
      format.html { redirect_to communities_path, notice: 'Community was successfully destroyed.' }
    end
  end

  protected

    def ensure_authorized
      return true if is_collection_action?
      resource = @member.present? ? @member : @community
      perspective = is_perspective_action? ? :as_anyone : :as_member
      authorize_action_for resource, community: @community, perspective: perspective
    end

    def set_community
      id = params[:id] || params[:community_id]
      @community = Community.find(id) rescue nil if id.present?
      @community ||= Community.new(community_params[:community])
    end

    def community_params
      params.permit(:community_id, :format, community: Community::FORM_FIELDS)
    end
end
