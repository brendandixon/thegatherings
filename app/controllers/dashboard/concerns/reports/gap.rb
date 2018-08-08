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

        categories = options[:categories] || community.categories.map{|ts| ts.name}
        categories = community.categories.find_all{|ts| categories.include?(ts.name)}

        return categories.map do |category|
          gaps = []

          category.tags.each do |tag|
            gaps << {
              name: tag.prompt,
              available: gatherings.tagged_with(tag).sum(:maximum),
              requested: preferences.tagged_with(tag).count
            }
          end
          {
            groupType: group.class.to_s.underscore,
            groupId: group.id,
            category: category.name,
            single: category.single,
            plural: category.plural,
            gaps: gaps
          }
        end
      end
    end
  end

  def gap
    respond_to do |format|
      @data = GapReport.data_for(@group, categories: params[:categories])
      format.json { render json: @data}
      format.html { render }
    end
  end

  def gap_params
    # params.permit()
  end

end
