# == Schema Information
#
# Table name: attendance_records
#
#  id            :integer          not null, primary key
#  meeting_id    :integer
#  membership_id :integer
#  attended      :boolean          default(FALSE), not null
#

class AttendanceRecordsController < ApplicationController

  before_action :set_attendance_record, except: COLLECTION_ACTIONS
  before_action :set_meeting
  before_action :set_member
  before_action :ensure_meeting
  before_action :ensure_gathering
  before_action :ensure_community
  before_action :ensure_campus
  before_action :ensure_member
  before_action :ensure_authorized

  def index
    @attendance_records = AttendanceRecord.for_gathering(@gathering).all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @attendance_record.save
        format.html { redirect_to meeting_path(@meeting, on: @meeting.datetime.to_s(:date)), notice: 'Attendance record was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @attendance_record.attributes = attendance_record_params
    ensure_authorized
    respond_to do |format|
      if @attendance_record.save
        format.html { redirect_to meeting_path(@meeting, on: @meeting.datetime.to_s(:date)), notice: 'Attendance record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @attendance_record.destroy
    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting, on: @meeting.datetime.to_s(:date)), notice: 'Attendance record was successfully destroyed.' }
    end
  end

  private

    def ensure_authorized
      resource = is_collection_action? ? @gathering : @attendance_record
      authorize_action_for resource, community: @community, campus: @campus, gathering: @gathering
    end

    def ensure_campus
      @campus = @gathering.campus if @gathering.present?
    end

    def ensure_community
      @community = @gathering.community if @gathering.present?
    end

    def ensure_gathering
      redirect_to member_root_path if @attendance_record.meeting.blank? || !@attendance_record.meeting.persisted?
      @gathering = @attendance_record.meeting.gathering
    end

    def ensure_meeting
      @meeting ||= @attendance_record.meeting
    end

    def ensure_member
      @member ||= @attendance_record.membership.member if @attendance_record.present?
      redirect_to member_root_path if !is_collection_action? && (@member.blank? || (@attendance_record.persisted? && !@attendance_record.for_member?(@member)))
    end

    def set_attendance_record
      unless is_collection_action?
        @attendance_record = AttendanceRecord.find(params[:id]) rescue nil if params[:id].present?
        @attendance_record ||= AttendanceRecord.new(attendance_record_params)
        @attendance_record.attended = false if params[:absent].present?
        @attendance_record.attended = true if params[:present].present?
      end
    end

    def set_meeting
      @meeting = Meeting.find(params[:meeting_id]) rescue nil if params[:meeting_id].present?
    end

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

    def attendance_record_params
      params.permit(attendance_record: [:membership_id, :attended])
    end
end
