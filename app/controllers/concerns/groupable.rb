module Groupable
  extend ActiveSupport::Concern

  included do 
    before_action :set_resource, except: self::COLLECTION_ACTIONS
    before_action :set_community, only: self::GROUPABLE_ACTIONS
    before_action :set_campus, only: self::GROUPABLE_ACTIONS
    before_action :set_gathering, only: self::GROUPABLE_ACTIONS
    before_action :set_group, only: self::GROUPABLE_ACTIONS
    before_action :ensure_group
    before_action :ensure_campus
    before_action :ensure_community
    before_action :ensure_gathering
  end

  class_methods do
  end

  def ensure_campus
    @campus ||= @group.is_a?(Campus) ? @group : @group.campus
  end

  def ensure_community
    @community ||= @group.is_a?(Community) ? @group : @group.community
    redirect_to root_path if @community.blank?
  end

  def ensure_gathering
    @gathering ||= @group if @group.is_a?(Gathering)
  end

  def ensure_group
    @group ||= @resource.group unless is_collection_action?
  end

  def set_community
    @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
  end

  def set_campus
    @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
  end

  def set_gathering
    @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
  end

  def set_group
    @group = case
            when params.keys.include?("community_id") then @community
            when params.keys.include?("campus_id") then @campus
            when params.keys.include?("gathering_id") then @gathering
            end
    redirect_to member_root_path if @group.blank? && is_collection_action?
    @resource.group ||= @group unless is_collection_action?
  end

end
