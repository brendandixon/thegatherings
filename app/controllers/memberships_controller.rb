# == Schema Information
#
# Table name: memberships
#
#  id          :integer          not null, primary key
#  member_id   :integer          not null
#  group_id    :integer          not null
#  group_type  :string(255)      not null
#  active_on   :datetime         not null
#  inactive_on :datetime
#  participant :string(25)
#  role        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MembershipsController < ApplicationController
  include Groupable
  include MemberSignup

  before_action :ensure_authorized

  def index
    @memberships = @group.memberships
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @membership.save
        establish_memberships
        format.html { redirect_to member_signup_path, notice: 'Membership was successfully created.' }
      else
        format.html { redirect_to :back }
      end
    end
  end

  def update
    @membership.attributes = membership_params[:membership]
    authorize_action_for @membership, community: @community, campus: @campus, gathering: @gathering
    respond_to do |format|
      if @membership.save
        format.html { redirect_to :back, notice: 'Membership was successfully updated.'}
        # format.html { redirect_to membership_path(@membership), notice: 'Membership was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    # TODO: Change to use url_for with @group
    url = case @membership.group
          when Campus then community_campuses_path(@community)
          when Community then communities_path
          when Gathering then community_gatherings_path(@community)
          else member_root_path
          end
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to url, notice: 'Membership was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @group : @membership
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
    end

    def ensure_community
      @community ||= @membership.community if @membership.present?
      super
    end

    def establish_memberships
      groups =  case
                when @gathering.present? then [@community, @campus]
                when @campus.present? then [@community]
                else []
                end
      groups.each {|group| @membership.member.join!(group) if group.present?}
    end

    def set_resource
      if !is_collection_action?
        @membership = Membership.find(params[:id]) rescue nil if params[:id].present?
        @membership ||= Membership.new(membership_params[:membership])
        @membership.member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
        @membership.participant = "member" if @membership.role.blank?
      end
      @resource = @membership
    end

    def membership_params
      params.permit(membership: [:member_id, :group_id, :group_type, :active_on, :inactive_on, :participant, :role])
    end

end
