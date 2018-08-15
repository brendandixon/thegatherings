class MembersController < ApplicationController

  authority_actions memberships: :read, activate: :update, deactivate: :update
  
  before_action :set_campus, only: COLLECTION_ACTIONS
  before_action :set_community, only: COLLECTION_ACTIONS
  before_action :set_gathering, only: COLLECTION_ACTIONS
  before_action :set_member, except: COLLECTION_ACTIONS
  before_action :ensure_community, only: COLLECTION_ACTIONS
  before_action :ensure_group, only: COLLECTION_ACTIONS
  before_action :ensure_authorized

  def index
    @members = @community.members
    @members = @members.for_campus(@campus) if @campus.present?
    @members = @members.for_community(@community) if @community.present?
    @members = @members.for_gathering(@gathering) if @gathering.present?
  end

  def show
    respond_to do |format|
      format.html { render }
      format.json { render json: @member.as_json(deep: true) }
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

  private

    def ensure_authorized
      resource = is_collection_action? ? @group : @member
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
    end

    def ensure_community
      @community ||= @gathering.community if @gathering.present?
      @community ||= @campus.community if @campus.present?
      @community ||= current_member.default_community
    end

    def ensure_group
      @group = @gathering || @campus || @community
    end

    def set_campus
      @campus = Campus.find(params[:campus_id]) rescue nil if params[:campus_id].present?
    end
    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
    end

    def set_member
      @member = Member.find(params[:id]) rescue nil
      @member ||= Member.find(params[:member_id]) rescue nil
    end

    def member_params
      params.permit(:campus_id, :community_id, :gathering_id, :member_id, member: Member::FORM_FIELDS + [:password, :password_confirmation])
    end

end
