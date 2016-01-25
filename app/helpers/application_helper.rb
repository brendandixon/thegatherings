module ApplicationHelper

  TIME_DISPLAY_FORMAT = "%l:%M %p"

  # TODO: Write a real matrix layout
  def matrix_layout(length, min_column_width, max_column_width, width)
    columns = 3.0
    rows = (length / columns).ceil-1
    column_width = 4
    matrix = []

    columns = columns.to_i
    0.upto(rows).each do |r|
      i = r * columns
      matrix << (i...[i + columns, length].min).to_a
    end

    return matrix, columns, column_width
  end

  def meeting_times
    @meeting_times ||= begin
                        d1 = DateTime.current.beginning_of_day
                        d2 = d1.end_of_day
                        a = []
                        while d1 <= d2
                          a << [d1.strftime(TIME_DISPLAY_FORMAT), d1.seconds_since_midnight]
                          d1 += 30.minutes
                        end
                        a
                      end
  end

end
