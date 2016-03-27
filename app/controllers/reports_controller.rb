class ReportsController < ApplicationController

  COLLECTION_ACTIONS += %w(gap attendance)
  GROUPABLE_ACTIONS = COLLECTION_ACTIONS
  include Groupable

  COLLECTION_ACTIONS.each do |action|
    authority_actions action => :update
  end

  before_action :ensure_authorized

  def index
  end

  def attendance
    @attendance = {
      container: "#attendance_chart",
      data: [
        ["Present", "Absent"]
      ],
      categories: []
    }
    query = case @group
            when Community then Meeting.for_community(@group)
            when Campus then Meeting.for_campus(@group)
            else @gathering.meetings
            end
    week_start = DateTime.now.beginning_of_month - 3.months
    week_end = week_start.end_of_week
    present = 0
    absent = 0
    query.since(week_start).by_datetime.each do |m|
      if m.datetime <= week_end
        present += m.number_present
        absent += m.number_absent
      else
        @attendance[:data] << [ present, absent ]
        @attendance[:categories] << week_start.to_s(:date)
        week_start = week_end + 1.second
        week_end = week_start.end_of_week
        present = m.number_present
        absent = m.number_absent
      end
    end
  end

  def gap
    @gaps = []
    Taggable::TAGS.each do |tags|
      gap = {
        container: "##{tags}_chart",
        data: [
          ["Available", "Requests"]
        ],
        categories: []
      }
      Taggable.values_for(tags).each do |v|
        tags = tags.pluralize.to_sym if tags.is_a?(String)
        gap[:data] << [
          Gathering.for_community(@community).tagged_with([v], on: tags).sum(:maximum),
          Membership.for_group(@community).tagged_with([v], on: tags).count
        ]
        gap[:categories] << I18n.t(v, scope:[:charts, tags])
      end
      @gaps << gap
    end
  end

  private

    def ensure_authorized
      raise Authority::SecurityViolation.new(current_member, "read the #{self.action_name} report", @group) unless current_member.can_read?(@group, scope: :as_overseer)
    end

end
