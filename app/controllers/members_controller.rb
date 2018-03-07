class MembersController < ApplicationController

  authority_actions mygatherings: :read
  
  before_action :set_member, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :set_campus
  before_action :ensure_authorized

  def index
    authorize_action_for @community, context: :as_member
    @members = @community.members
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      begin
        @member.save!
        @member.join!(@community)
        begin_signup_for(@member, @community)
        @member.send_reset_password_instructions
        format.html { redirect_to signup_path_for(@member), notice: 'Member was successfully created.' }
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
        @member.errors.add(:email, I18n.t(:not_unique, scope:[:errors, :common])) if e.is_a?(ActiveRecord::RecordNotUnique)
        format.html { render :new }
      end
    end
  end

  def update
    @member.attributes = member_params[:member]
    ensure_authorized
    respond_to do |format|
      if @member.save
        format.html { redirect_to new_community_member_path(@community, @member), notice: 'Member was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Member was successfully destroyed.' }
    end
  end

  def mygatherings
    render :show
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @campus : @member
      context = is_collection_action? || in_signup_for?(@member) ? :as_member : :as_leaders
      authorize_action_for resource, campus: @campus, context: context
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
      @campus ||= current_member.active_campuses.first.group if current_member.active_campuses.present?
      @campus = nil unless @campus.present? && @community == @campus.community
    end

    def set_community
      @community = Community.find(param[:community_id]) rescue nil if params[:community_id].present?
      @community ||= current_member.active_communities.first.group if current_member.active_communities.present?
    end

    def set_member
      @member = Member.find(params[:id]) rescue nil
      @member ||= self.action_name == "mygatherings" ? current_member : Member.new(member_params[:member])
      redirect_to member_root_path if @member.blank?
    end

    def member_params
      params.permit(:campus_id, :community_id, member: Member::FORM_FIELDS + [:password, :password_confirmation])
    end

end
