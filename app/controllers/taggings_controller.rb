class TaggingsController < ApplicationController

  COLLECTION_ACTIONS = COLLECTION_ACTIONS + %w(add remove set)

  authority_actions add: :update, remove: :update, set: :update

  before_action :set_tagging, except: COLLECTION_ACTIONS
  before_action :set_resource
  before_action :set_community
  before_action :ensure_authorized

  def index
    @taggings = @resource.taggings
    respond_to do |format|
      format.html { render }
      format.json { render json: @taggings.as_json }
    end
  end

  def create
    respond_to do |format|
      if @tagging.save
        format.html { redirect_to taggings_path, notice: 'Tagging was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @tagging.destroy
    respond_to do |format|
      format.html { redirect_to taggings_path, notice: 'Tagging was successfully destroyed.' }
    end
  end

  def add
  end

  def remove
  end

  def set
    taggings = params[:taggings].permit!
    respond_to do |format|
      if @resource.set_tags(taggings.to_hash)
        format.json { render json:@resource.taggings }
      else
        format.json { render json:@resource.errors.as_json, status: :bad_request }
      end
    end
  end

  private

    def ensure_authorized
      authorize_action_for @resource
    end

    def set_community
      @community = @resource.community if @resource.present?
    end

    def set_resource
      if params[:gathering_id].present?
        @resource = Gathering.find(params[:gathering_id]) rescue nil
      elsif params[:preference_id].present?
        @resource = Preference.find(params[:preference_id]) rescue nil
      end
      redirect_to root_path unless @resource.present?
    end

    def set_tagging
      @tagging = Tagging.find(params[:id]) rescue nil if params[:id].present?
      @tagging ||= Tagging.new(tagging_params[:tagging])
    end

    def tagging_params
      params.permit(:format, :gathering_id, :preference_id, tagging: Tagging::FORM_FIELDS, taggings: {})
    end

    def taggings_path
      return gathering_taggings_path(@resource) if @resource.is_a?(Gathering)
      return preference_taggings_path(@resource) if @resource.is_a?(Preference)
      return root_path
    end
end
