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
  end

  def gap
  end

  private

    def ensure_authorized
      raise Authority::SecurityViolation.new(current_member, "read the #{self.action_name} report", @group) unless current_member.can_read?(@group, scope: :as_leader)
    end

end
