# == Schema Information
#
# Table name: attendance_records
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  datetime     :datetime         not null
#

class AttendanceRecordsController < ApplicationController

  before_action :set_attendance_record, except: COLLECTION_ACTIONS
  before_action :set_gathering
  before_action :set_member
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
        format.html { redirect_to gather_gathering_path(@attendance_record.gathering, on: @attendance_record.datetime.to_s(:date)), notice: 'Attendance record was successfully created.' }
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
        format.html { redirect_to gather_gathering_path(@attendance_record.gathering, on: @attendance_record.datetime.to_s(:date)), notice: 'Attendance record was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @attendance_record.destroy
    respond_to do |format|
      format.html { redirect_to gather_gathering_path(@attendance_record.gathering, on: @attendance_record.datetime.to_s(:date)), notice: 'Attendance record was successfully destroyed.' }
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
      @gathering ||= @attendance_record.gathering
      redirect_to member_root_path if @gathering.blank? || (@attendance_record.persisted? && !@attendance_record.belongs_to_gathering?(@gathering))
    end

    def ensure_member
      @member ||= @attendance_record.member if @attendance_record.present?
      redirect_to member_root_path if !is_collection_action? && (@member.blank? || (@attendance_record.persisted? && !@attendance_record.belongs_to_member?(@member)))
    end

    def set_attendance_record
      unless is_collection_action?
        @attendance_record = AttendanceRecord.find(params[:id]) rescue nil if params[:id].present?
        @attendance_record ||= AttendanceRecord.new(attendance_record_params)
      end
    end

    def set_gathering
      @gathering = Gathering.find(params[:gathering_id]) rescue nil if params[:gathering_id].present?
    end

    def set_member
      @member = Member.find(params[:member_id]) rescue nil if params[:member_id].present?
    end

    def attendance_record_params
      params.permit(:member_id, :gathering_id, :datetime)
    end
end
