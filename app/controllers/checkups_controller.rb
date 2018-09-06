class CheckupsController < ApplicationController

  before_action :set_campus
  before_action :set_community
  before_action :set_gathering
  before_action :set_checkup
  before_action :set_checkup, except: COLLECTION_ACTIONS
  before_action :ensure_gathering
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_group
  before_action :ensure_checkup, except: COLLECTION_ACTIONS
  before_action :ensure_authorized

  def index
    @checkups = @group.checkups
    respond_to do |format|
      format.html { render }
      format.json { render json:@checkups.as_json }
    end
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json:@checkup.as_json }
    end
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @group : @checkup
      perspective = is_collection_action? ? :as_leader : :as_member
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering, perspective: perspective
    end

    def ensure_campus
      @campus ||= @checkup.campus if @checkup.present?
      @campus ||= @gathering.campus if @gathering.present?
      @campus ||= current_member.default_campus
    end

    def ensure_community
      @community ||= @checkup.community if @checkup.present?
      @community ||= @gathering.community if @gathering.present?
      @community ||= @campus.community if @campus.present?
      @community ||= current_member.default_community
    end

    def ensure_gathering
      @gathering ||= @checkup.gathering if @checkup.present?
    end

    def ensure_group
      @group = @gathering || @campus || @community
    end

    def ensure_checkup
      @checkup ||= Checkup.new(params[:checkup])
      @checkup.gathering ||= @gathering
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    end
    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
    end

    def set_checkup
      @checkup = Checkup.find(params[:id]) rescue nil if params[:id].present?
      @checkup ||= Checkup.find(params[:checkup_id]) rescue nil if params[:checkup_id].present?
    end

    def checkup_params
      params.permit(:campus_id, :community_id, :format, :gathering_id, :checkup_id, checkup: Checkup::FORM_FIELDS)
    end
end
