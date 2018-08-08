module Reports::Attendance
  extend ActiveSupport::Concern

  class AttendanceReport
    class<<self
      # JSON Format
      # {
      #   groupType: <group>,
      #   groupId: <group_id>,
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
        query.since(week_start).by_datetime.each do |m|
          if m.datetime <= week_end
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
