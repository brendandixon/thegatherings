class RequestMatch

  attr_reader :gathering, :matches

  class<<self

    def matches_for(request)
      return [] unless request.present? && request.campus.present? && request.membership.present?

      campus = request.campus
      community = request.community
      categories = community.categories.in_order
      preferences = community.preferences.for_member(request.member).take

      campus.gatherings.is_open.map do |g|
        matches = categories.map do |category|
          CategoryMatch.match_for(category, preferences.tags_for(category), g.tags_for(category))
        end
        RequestMatch.new(g, matches)
      end
    end

  end

  protected

    def initialize(gathering, matches)
      @gathering = gathering
      @matches = matches
    end

end
