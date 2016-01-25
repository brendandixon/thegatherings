# == Schema Information
#
# Table name: members
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  gender                 :string(25)       default(""), not null
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)
#  postal_code            :string(25)
#  country                :string(2)
#  time_zone              :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#

class MembersController < ApplicationController
  include MemberSignup

  authority_actions mygatherings: :read
  
  before_action :set_member, except: COLLECTION_ACTIONS
  before_action :set_community
  before_action :ensure_authorized

  def index
    authorize_action_for @community, scope: :as_member
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
        begin_member_signup(@member, @community)
        @member.send_reset_password_instructions
        format.html { redirect_to member_signup_path, notice: 'Member was successfully created.' }
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
      resource = is_collection_action? ? @community : @member
      authorize_action_for resource, community: @community
    end

    def set_community
      @community = Community.find(params[:community_id]) rescue nil if params[:community_id].present?
      @community ||= current_member.communities.first
    end

    def set_member
      @member = Member.find(params[:id]) rescue nil
      @member ||= self.action_name == "mygatherings" ? current_member : Member.new(member_params[:member])
      redirect_to member_root_path if @member.blank?
    end

    def member_params
      params.permit(member: [:first_name, :last_name, :gender, :email, :phone, :postal_code, :password, :password_confirmation])
    end

end
