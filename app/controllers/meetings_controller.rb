# == Schema Information
#
# Table name: meetings
#
#  id           :integer          not null, primary key
#  gathering_id :integer          not null
#  datetime     :datetime         not null
#  canceled     :boolean          default(FALSE), not null
#

class MeetingsController < ApplicationController

  before_action :set_meeting, except: COLLECTION_ACTIONS
  before_action :set_gathering
  before_action :ensure_gathering
  before_action :ensure_community
  before_action :ensure_campus
  before_action :ensure_authorized

  def index
    @meetings = Meeting.for_gathering(@gathering).all
  end

  def show
  end

  def edit
  end

  def create
    @meeting.datetime = Timeliness.parse(params[:on], :date, format: "yyyy-mm-dd") if params[:on].present?
    @meeting.datetime ||= Time.zone.now
    @meeting.datetime = @gathering.prior_meeting(@meeting.datetime.end_of_day)

    respond_to do |format|
      begin
        @meeting.save!
        @meeting.ensure_attendees
      rescue ActiveRecord::RecordNotUnique
        @meeting = @gathering.meetings.for_datetime(@meeting.datetime).take
      rescue ActiveRecord::RecordInvalid
      end

      if @meeting.persisted?
        format.html { redirect_to meeting_path(@meeting), notice: 'Meeting was successfully created.' }
      else
        format.html { redirect_to gathering_path(@gathering) }
      end
    end
  end

  def update
    @meeting.attributes = meeting_params
    ensure_authorized
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to meeting_path(@meeting), notice: 'Meeting was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to gathering_path(@meeting.gathering), notice: 'Meeting was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @gathering : @meeting
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
    end

    def ensure_campus
      @campus = @gathering.campus if @gathering.present?
    end

    def ensure_community
      @community = @gathering.community if @gathering.present?
    end

    def ensure_gathering
      @gathering ||= @meeting.gathering
      redirect_to member_root_path if @gathering.blank? || (@meeting.persisted? && @meeting.gathering != @gathering)
    end

    def set_meeting
      unless is_collection_action?
        @meeting = Meeting.find(params[:id]) rescue nil if params[:id].present?
        @meeting ||= Meeting.new(meeting_params)
      end
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
      @meeting.gathering ||= @gathering unless @meeting.persisted?
    end

    def meeting_params
      params.permit(meeting: [:gathering_id, :datetime, :canceled])
    end
end
