module Dashboard
  class ReportsController < DashboardController
    include Reports

    COLLECTION_ACTIONS += %w(attendance gap)
    authority_actions attendance: :update, gap: :update

    def show
    end

  end
end
