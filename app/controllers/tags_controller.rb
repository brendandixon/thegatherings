class TagsController < ApplicationController

  before_action :set_resource_and_community
  before_action :ensure_authorized

  def edit
    render :edit
  end

  def update
    ensure_authorized
    params = tag_params[:tags]
    @resource.class.transaction do
      params.keys.each do |tag_set|
        @resource.set_tags!(*params[tag_set], tag_set: tag_set)
      end
    end
    respond_to do |format|
      if @resource.save
        format.html { redirect_to after_update_path, notice: "#{@resource_type.to_s.classify} was successfully updated." }
      else
        format.html { render :edit }
      end
    end
  end

  private

    def after_update_path
      return signup_path_for(@resource.member) if for_preference? && in_signup_for?(@resource.member)
      return gathering_path(id: @resource.id) if for_gathering?
      return community_member_path(community_id: @resource.community, id: @resource.member.id) if for_preference?
      member_root_path
    end

    def ensure_authorized
      context = in_signup_for?(@resource.member) ? :as_signup : :as_leader
      authorize_action_for @resource, community: @community, context: context
    end

    def for_gathering?
      @mode == :gathering
    end

    def for_preference?
      @mode == :preference
    end

    def set_resource_and_community
      if params[:gathering_id].present?
        @mode = :gathering
        @resource = Gathering.find(params[:gathering_id])
        @resource_type = :gathering
      elsif params[:preference_id].present?
        @mode = :preference
        @resource = Preference.find(params[:preference_id])
        @resource_type = :preference
      else
        raise
      end
      @community = @resource.community
      
      @tag_sets = params[:tag_sets].split(',').map{|t| @community.tag_sets.with_name(t).take} if params[:tag_sets].present?
      @tag_sets ||= []
      @tag_sets.compact!
      @tag_sets = @community.tag_sets if @tag_sets.empty?

    rescue Exception => e
      dump_exception(e)
      redirect_to member_root_path
    end

    def tag_params
      params.require(@resource_type).permit(tags: {})
    end

end
