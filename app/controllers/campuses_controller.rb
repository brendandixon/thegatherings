# == Schema Information
#
# Table name: campuses
#
#  id                 :integer          not null, primary key
#  community_id       :integer          not null
#  name               :string(255)
#  contact_first_name :string(255)
#  contact_last_name  :string(255)
#  email              :string(255)
#  phone              :string(255)
#  street_primary     :string(255)
#  street_secondary   :string(255)
#  city               :string(255)
#  state              :string(255)
#  postal_code        :string(255)
#  time_zone          :string(255)
#  country            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active_on          :datetime
#  inactive_on        :datetime
#

class CampusesController < ApplicationController

  before_action :set_campus, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_community
  before_action :ensure_authorized

  def index
    @campuses = @community.campuses
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @campus.save
        format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @campus.attributes = campus_params[:campus]
    ensure_authorized
    respond_to do |format|
      if @campus.save
        format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @campus.destroy
    respond_to do |format|
      format.html { redirect_to campus_path(@campus), notice: 'Campus was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @community : @campus
      scope = is_scoped_action? ? :as_anyone : :as_member
      authorize_action_for resource, community: @community, scope: scope
    end

    def ensure_community
      @community ||= @campus.community if @campus.present?
      redirect_to member_root_path if @community.blank? || (@campus.present? && @community.id != @campus.community_id)
    end

    def set_campus
      @campus = Campus.find(params[:id]) rescue nil if params[:id].present?
      @campus ||= Campus.new(campus_params[:campus])
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      @campus.community ||= @community if @campus.present?
    end

    def campus_params
      params.permit(campus: [:name, :contact_first_name, :contact_last_name, :email, :phone, *Campus.address_fields, :active_on, :inactive_on])
    end
end
