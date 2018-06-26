class TagSetsController < ApplicationController

  before_action :set_tag_set, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    @tag_sets = @community.tag_sets
    respond_to do |format|
      format.html { render }
      format.json { render json: @tag_sets.as_json }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @tag_set.as_json }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @tag_set.save
        format.html { redirect_to tag_set_path(@tag_set), notice: 'Tag set was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @tag_set.attributes = tag_set_params[:tag_set]
    ensure_authorized
    respond_to do |format|
      if @tag_set.save
        format.html { redirect_to tag_set_path(@tag_set), notice: 'Tag set was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @tag_set.destroy
    respond_to do |format|
      format.html { redirect_to tag_set_path(@tag_set), notice: 'Tag set was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      context = is_contextual_action? ? :as_anyone : :as_member
      authorize_action_for @community, context: context
    end

    def ensure_community
      @community ||= @tag_set.community if @tag_set.present?
      redirect_to member_root_path if @community.blank? || (@tag_set.present? && @community.id != @tag_set.community_id)
    end

    def set_tag_set
      @tag_set = TagSet.find(params[:id]) rescue nil if params[:id].present?
      @tag_set ||= TagSet.new(tag_set_params[:tag_set])
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      @tag_set.community ||= @community if @tag_set.present?
    end

    def tag_set_params
      params.permit(tag_set: TagSet::FORM_FIELDS)
    end
end
