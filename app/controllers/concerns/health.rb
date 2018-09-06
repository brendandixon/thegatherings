module Health
  extend ActiveSupport::Concern

  included do
    authority_actions health: :read
  end

  class_methods do
  end

  def health
    # TODO: Add period support
    group = @gathering || @campus || @community
    health = HealthRecord.health_for(group)
    respond_to do |format|
      format.json { render json:health }
    end
  end

  protected

end
