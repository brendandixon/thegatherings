module Reports::Gap
  extend ActiveSupport::Concern

  class GapReport
    class<<self
      # JSON Format
      # {
      #   group: <group>_<group_id>,
      #   categories: {
      #     "<tag category>" : {
      #         "single" : <string>,
      #         "plural" : <string>,
      #         "gaps" : {
      #           "<tag value>" : {
      #             "available" : <num>,
      #             "requests"  : <num>
      #           }
      #         }
      #      },
      #      . . .
      #   }
      # }
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

        categories = {}
        community.tag_sets.each do |tag_set|
          gaps = {}

          tag_set.tags.each do |tag|
            gaps[tag.name] = {
              available: gatherings.tagged_with(tag).sum(:maximum),
              requests: preferences.tagged_with(tag).count
            }
          end

          categories[tag_set.name] = {
            single: tag_set.single,
            plural: tag_set.plural,
            gaps: gaps
          }
        end

        {
          group: "#{group.class.to_s.underscore}_#{group.id}",
          categories: categories
        }
      end

      # JSON Format
      # [
      #   {
      #     container: <group>_<group_id>_<tag_set_name>,
      #     single: <tag set singular name>,
      #     plural: <tag set plural name>,
      #     labels: [<tag value>, . . .],
      #     available: {
      #       name: 'Available',
      #       values: [<num>, <num>, . . .]
      #     },
      #     requests: {
      #       name: 'Requests',
      #       values: [<num>, <num>, . . .]
      #     }
      #   },
      #   . . .
      # ]
      def to_chartjs(data)
        categories = []
        group = data[:group]
        data[:categories].each do |name, details|
          category = {
            container: "#{group}_#{name}",
            single: details[:single],
            plural: details[:plural],
          }
          labels = []
          available = []
          requests = []
          details[:gaps].each do |tag, gaps|
            labels << tag
            available << gaps[:available]
            requests << gaps[:requests]
          end
          category[:labels] = labels
          category[:available] = {
            name: 'Available',
            values: available
          }
          category[:requests] = {
            name: 'Requests',
            values: requests
          }
          categories << category
        end
        categories
      end
    end
  end

  def gap
    respond_to do |format|
      data = GapReport.data_for(@group)
      format.html do
        @chart_data = GapReport.to_chartjs(data)
        render
      end
    end
  end

end
