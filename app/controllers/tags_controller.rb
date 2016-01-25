class TagsController < ApplicationController
  include MemberSignup

  before_action :set_resource_and_community
  before_action :ensure_authorized

  def edit
    render :edit
  end

  def update
    @resource.attributes = tag_params
    ensure_authorized
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
      case
      when for_gathering? then gathering_path(@resource)
      when in_member_signup? then member_signup_path
      else membership_path(@resource)
      end
    end

    def ensure_authorized
      authorize_action_for @resource, community: @community
    end

    def for_gathering?
      @mode == :gathering
    end

    def for_membership?
      @mode == :preference
    end

    def set_resource_and_community
      if params[:gathering_id].present?
        @mode = :gathering
        @resource = Gathering.find(params[:gathering_id])
        @resource_type = :gathering
        @community = @resource.community
      elsif params[:membership_id].present?
        @mode = :preference
        @resource = Membership.find(params[:membership_id])
        @resource_type = :membership
        @community = @resource.group
      end
      @tags = params[:tags].present? ? (params[:tags].split(',').map{|t| t.strip} & Taggable::TAGS) : Taggable::TAGS
    rescue
      redirect_to :root
    end

    def tag_params
      params.require(@resource_type).permit(:signup, Taggable::TAGS.inject({}) {|h, tag| h["#{tag}_list".to_sym] = []; h})
    end

end
