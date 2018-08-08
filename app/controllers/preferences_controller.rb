class PreferencesController < ApplicationController
  include HasMembers

  COLLECTION_ACTIONS = COLLECTION_ACTIONS + %w(search)

  authority_actions search: :read

  before_action :set_preference, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :set_member
  before_action :ensure_community
  before_action :ensure_member
  before_action :ensure_preference
  before_action :ensure_authorized

  def index
    @preferences = @community.preferences
    respond_to do |format|
      format.html { render }
      format.json { render json: @preferences.as_json }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @preference.as_json }
    end
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @preference.save
        format.html { render }
        format.json { render json:@preference.as_json }
      else
        format.html { redirect_to :back }
        format.json { render json:@preference.as_json }
      end
    end
  end

  def update
    @preference.attributes = preference_params[:preference]
    authorize_action_for @preference, community: @community
    respond_to do |format|
      if @preference.save
        format.html { render }
        format.json { render json:@preference.as_json }
      else
        format.html { render :edit }
        format.json { render json:@preference.as_json }
      end
    end
  end

  def destroy
    @preference.destroy
    respond_to do |format|
      format.html { redirect_to member_path(@member), notice: 'Preference was successfully destroyed.' }
      format.json { render json:@preference.as_json }
    end
  end

  def search
    @preferences = Preference
    @preferences = @preferences.for_community(@community) if @community.present?
    @preferences = @preferences.for_member(@member) if @member.present?
    respond_to do |format|
      format.html { render :index }
      format.json { render json:@preferences.as_json }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @community : @preference
      perspective = is_collection_action? ? :as_member : :as_leader
      authorize_action_for resource, community: @community, perspective: perspective
    end

    def ensure_community
      @community ||= @preference.community if @preference.present?
    end

    def ensure_preference
      if @preference.blank?
        @preference = Preference.new(preferences_params[:preference])
        @preference.community = @community unless @preference.community.present?
        @preference.member = @member unless @preference.member.present?
      end
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

    def set_preference
      @preference = Preference.find(params[:id]) rescue nil if params[:id].present?
    end

    def preferences_params
      params.permit(:community_id, :format, :member_id, preference: Preference::FORM_FIELDS)
    end

end
