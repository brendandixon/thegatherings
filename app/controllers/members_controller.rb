class MembersController < ApplicationController

  authority_actions mygatherings: :read, memberships: :read, activate: :update, deactivate: :update
  
  before_action :set_member, except: COLLECTION_ACTIONS
  before_action :set_joinable
  before_action :ensure_joinables
  before_action :ensure_authorized

  def index
    authorize_action_for @community, perspective: :as_member
    @members = @community.members
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @member.as_json }
    end
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

  def memberships
    @joinables = @member.send(params[:joinable_type]) rescue []
    respond_to do |format|
      format.html { render }
      format.json { render json: @joinables.as_json }
    end
  end

  def mygatherings
    render :show
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @joinable : @member
      if @joinable.is_a?(Community)
        authorize_action_for resource, community: @community
      elsif @joinable.is_a?(Campus)
        authorize_action_for resource, community: @community, campus: @campus
      elsif @joinable.is_a?(Gathering)
        authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
      else
        authorize_action_for resource, community: @community, campus: @campus
      end
    end

    def ensure_joinables
      if @joinable.is_a?(Community)
        @community = @joinable
      elsif @joinable.is_a?(Campus)
        @campus = @joinable
        @community = @campus.community
      elsif @joinable.is_a?(Gathering)
        @gathering = @joinable
        @campus = @gathering.campus
        @community = @gathering.community
      else
        @community = current_member.default_community
        @campus = current_member.default_campus(@community)
      end
    end

    def set_joinable
      if params[:community_id].present?
        @joinable = Community.find(params[:community_id]) rescue nil
      elsif params[:campus_id].present?
        @joinable = Campus.find(params[:campus_id]) rescue nil
      elsif params[:gathering_id].present?
        @joinable = Gathering.find(params[:gathering_id]) rescue nil
      elsif params[:joinable_type].present? && params[:joinable_id].present?
        @joinable = params[:joinable_type].classify.constantize.find(params[:joinable_id]) rescue nil
      end
    end

    def set_member
      @member = Member.find(params[:id]) rescue nil
      @member ||= self.action_name == "new" ? Member.new(member_params[:member]) : current_member
      redirect_to member_root_path if @member.blank?
    end

    def member_params
      params.permit(:campus_id, :community_id, member: Member::FORM_FIELDS + [:password, :password_confirmation])
    end

end
