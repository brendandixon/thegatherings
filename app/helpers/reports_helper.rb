module ReportsHelper

  # JSON Format
  # {
  #   "<group>_<group id>" : {
  #       "<date>" : {
  #         "present" : <num>,
  #         "absent"  : <num>
  #       },
  #       . . .
  #     }
  # }
  def attendance_for(groups, options = {})
    attendance = {}
    groups.each do |group|
      group_data = {}
      query = group.meetings
      week_start = Time.zone.now.beginning_of_month - 3.months
      week_end = week_start.end_of_week
      present = 0
      absent = 0
      query.since(week_start).by_datetime.each do |m|
        if m.datetime <= week_end
          present += m.number_present
          absent += m.number_absent
        else
          group_data[week_start.to_s(:date)] = {
            present: present, absent: absent
          }
          week_start = week_end + 1.second
          week_end = week_start.end_of_week
          present = m.number_present
          absent = m.number_absent
        end
      end
      attendance["#{group.class.to_s.downcase}_#{group.id}"] = group_data
    end
    attendance
  end

  # JSON Format
  # {
  #   "<tag category>" : {
  #       "<tag value>" : {
  #         "available" : <num>,
  #         "requests"  : <num>
  #       },
  #       . . .
  #     }
  # }
  def gaps_for(community)
    gaps = {}
    Taggable::TAGS.each do |tag|
      gap = {}
      tags = tag.pluralize.to_sym
      Taggable.values_for(tag).each do |v|
        gap[v.to_sym] = {
          available: Gathering.for_community(community).tagged_with([v], on: tags).sum(:maximum),
          requests: Membership.for_group(community).tagged_with([v], on: tags).count
        }
      end
      gaps[tag.to_sym] = gap
    end
    gaps
  end

  def convert_for_chart(data)
    chart_data = []
    data.each do |segment, values|
      segment_data = {
        container: "##{segment}_chart",
        data: [],
        categories: []
      }
      values.each do |v, d|
        segment_data[:data] << d.keys.map{|k| I18n.t(k, scope:[:charts])} if segment_data[:data].blank?
        segment_data[:data] << d.values
        segment_data[:categories] << I18n.t(v, scope:[:charts, segment], default: v)
      end
      chart_data << segment_data
    end
    chart_data
  end

end
