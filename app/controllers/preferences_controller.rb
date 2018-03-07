class PreferencesController < ApplicationController

  before_action :set_preference, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    @preferences = @community.preferences
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @preference.save
        format.html { redirect_to signup_path_for(@preference.member), notice: 'Preference was successfully created.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def update
    @preference.attributes = preference_params[:preference]
    authorize_action_for @preference, community: @community
    respond_to do |format|
      if @preference.save
        format.html { redirect_to :back, notice: 'Preference was successfully updated.'}
        # format.html { redirect_to preference_path(@preference), notice: 'Preference was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @preference.destroy
    respond_to do |format|
      format.html { redirect_to community_preferences_path(@community), notice: 'Preference was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @community : @preference
      context = is_collection_action? || in_signup_for?(@preference.member) ? :as_member : :as_leader
      authorize_action_for resource, community: @community, context: context
    end

    def ensure_community
      @community ||= @preference.community if @preference.present?
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_preference
      @preference = Preference.find(params[:id]) rescue nil if params[:id].present?
      @preference ||= Preference.new(preferences_params[:preference])
    end

    def preferences_params
      params.permit(gathering: Preference::FORM_FIELDS)
    end

end
