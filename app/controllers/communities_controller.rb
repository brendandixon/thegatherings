# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CommunitiesController < ApplicationController

  before_action :set_community, except: COLLECTION_ACTIONS
  before_action :ensure_authorized

  def index
    @communities = Community.all
  end

  def show
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

  private

    def ensure_authorized
      if !is_collection_action?
        scope = is_scoped_action? ? :as_anyone : :as_member
        authorize_action_for @community, scope: scope
      end
    end

    def set_community
      @community = Community.find(params[:id]) rescue nil if params[:id].present?
      @community ||= Community.new(community_params[:community])
    end

    def community_params
      params.permit(community: [:name, :path, :active_on, :inactive_on, :time_zone])
    end
end
