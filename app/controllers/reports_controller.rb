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
    respond_to do |format|
      attendance_data = ReportsController.helpers.attendance_for([@group])
      format.html do
        @chart_data = ReportsController.helpers.convert_for_chart(attendance_data)
        render "attendance"
      end
    end
  end

  def gap
    respond_to do |format|
      gaps_data = ReportsController.helpers.gaps_for(@community)
      format.html do
        @chart_data = ReportsController.helpers.convert_for_chart(gaps_data)
        render "gap"
      end
    end
  end

  private

    def ensure_authorized
      raise Authority::SecurityViolation.new(current_member, "read the #{self.action_name} report", @group) unless current_member.can_read?(@group, scope: :as_overseer)
    end

end
