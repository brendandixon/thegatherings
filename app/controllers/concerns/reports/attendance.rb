module Reports::Attendance
  extend ActiveSupport::Concern

  class AttendanceReport
    class<<self
      # JSON Format
      # {
      #   group: <group>_<group_id>,
      #   attendance : {
      #     "<date>" : {
      #       "present" : <num>,
      #       "absent"  : <num>
      #     },
      #     . . .
      #   }
      # }
      def data_for(group, options = {})
        attendance = {}
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
            attendance[week_start.to_s(:date)] = {
              present: present, absent: absent
            }
            week_start = week_end + 1.second
            week_end = week_start.end_of_week
            present = m.number_present
            absent = m.number_absent
          end
        end
        {
          group: "#{group.class.to_s.underscore}_#{group.id}",
          attendance: attendance
        }
      end

      # JSON Format
      # {
      #   container: <group>_<group_id>,
      #   labels: [<date>, <date>, . . .],
      #   present: {
      #     name: 'Present',
      #     values: [<num>, <num>, . . .]
      #   },
      #   absent: {
      #     name: 'Absent',
      #     values: [<num>, <num>, . . .]
      #   },
      # }
      def to_chartjs(data)
        labels = []
        present = []
        absent = []
        data[:attendance].each do |k, v|
          labels << k
          present << v[:present]
          absent << v[:absent]
        end
        {
          container: data[:group],
          labels: labels,
          present: {
            name: 'Present',
            values: present
          },
          absent: {
            name: 'Absent',
            values: absent
          }
        }
      end
    end
  end

  def attendance
    respond_to do |format|
      data = AttendanceReport.data_for(@group)
      format.html do
        @chart_data = [AttendanceReport.to_chartjs(data)]
        render
      end
    end
  end

end
