module Reports::Attendance
  extend ActiveSupport::Concern

  class AttendanceReport
    class<<self
      # JSON Format
      # {
      #   groupType: <group>,
      #   groupId: <group_id>,
      #   averages: {
      #     absent: <num>,
      #     present: <num>
      #   },
      #   meetings: <num>
      #   attendance : {
      #     "<date>" : {
      #       "present" : <num>,
      #       "absent"  : <num>
      #     },
      #     . . .
      #   }
      # }
      def data_for(group, options = {})
        attendance = []
        query = group.meetings
        week_start = DateTime.current.beginning_of_month - 3.months
        week_end = week_start.end_of_week
        present = 0
        absent = 0
        total_absent = 0
        total_meetings = 0
        total_present = 0
        query.since(week_start).by_occurs.each do |m|
          total_absent += m.number_absent
          total_meetings += 1
          total_present += m.number_present
          if m.occurs <= week_end
            present += m.number_present
            absent += m.number_absent
          else
            attendance << {
              date: week_start.to_s(:date),
              present: present,
              absent: absent
            }
            week_start = week_end + 1.second
            week_end = week_start.end_of_week
            present = m.number_present
            absent = m.number_absent
          end
        end
        {
          groupType: group.class.to_s.underscore,
          groupId: group.id,
          averages: {
            absent: (total_absent / total_meetings).round,
            present: (total_present / total_meetings).round
          },
          meetings: total_meetings,
          attendance: attendance
        }
      end
    end
  end

  def attendance
    respond_to do |format|
      @data = AttendanceReport.data_for(@group)
      format.json { render json: @data}
      format.html { render }
    end
  end

end
