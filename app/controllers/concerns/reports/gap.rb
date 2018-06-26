module Reports::Gap
  extend ActiveSupport::Concern

  class GapReport
    class<<self
      # JSON Format
      # [
      #   {
      #     groupType: <group>,
      #     groupId: <group_id>
      #     category: <string>,
      #     single: <string>,
      #     plural: <string>,
      #     gaps : [
      #       {
      #         name: <string>,
      #         available: <num>,
      #         requested: <num>
      #       }
      #       . . .
      #     ]
      #   }
      # ]
      def data_for(group, options = {})
        if group.is_a?(Community)
          gatherings = Gathering.for_community(group)
          preferences = Preference.for_community(group)
          community = group
        elsif group.is_a?(Campus)
          gatherings = Gathering.for_campus(group)
          preferences = Preference.for_campus(group)
          community = group.community
        else
          return {}
        end

        return community.tag_sets.map do |tag_set|
          gaps = []

          tag_set.tags.each do |tag|
            gaps << {
              name: tag.name,
              available: gatherings.tagged_with(tag).sum(:maximum),
              requested: preferences.tagged_with(tag).count
            }
          end
          {
            groupType: group.class.to_s.underscore,
            groupId: group.id,
            category: tag_set.name,
            single: tag_set.single,
            plural: tag_set.plural,
            gaps: gaps
          }
        end
      end
    end
  end

  def gap
    respond_to do |format|
      @data = GapReport.data_for(@group)
      format.json { render json: @data}
      format.html { render }
    end
  end

  def gap_params
    # params.permit()
  end

end
