class ReportsController < ApplicationController
  include Reports

  COLLECTION_ACTIONS += %w(gap attendance)

  COLLECTION_ACTIONS.each do |action|
    authority_actions action => :update
  end

  before_action :set_community
  before_action :set_campus
  before_action :set_gathering
  before_action :ensure_campus
  before_action :ensure_community
  before_action :ensure_gathering
  before_action :ensure_authorized

  def index
  end

  private

    def ensure_authorized
      raise Authority::SecurityViolation.new(current_member, "read the #{self.action_name} report", @group) unless current_member.can_read?(@group, context: :as_overseer)
    end

    def ensure_campus
      @campus ||= @group.is_a?(Campus) ? @group : @group.campus
      @community = @campus.community if @campus.present?
    end

    def ensure_community
      @community ||= @group.is_a?(Community) ? @group : @group.community
      redirect_to root_path if @community.blank?
    end

    def ensure_gathering
      @gathering ||= @group if @group.is_a?(Gathering)
      if @gathering.present?
        @campus = @gathering.campus
        @community = @gathering.community
      end
    end

    def ensure_group
      @group ||= @resource.group unless is_collection_action?
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

end
