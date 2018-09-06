module Attendees
  extend ActiveSupport::Concern

  included do
    authority_actions attendees: :read
  end

  class_methods do
  end

  def attendees
    group = @gathering || @campus || @community
    gatherings = group.is_a?(Gathering) ? [group] : group.gatherings
    attendees = gatherings.inject(0){|total, g| total += g.members.count}
    respond_to do |format|
      format.json { render json:{ attendees: attendees, average: (attendees.to_f / gatherings.length).round.to_i }.as_json }
    end
  end

  protected

end
