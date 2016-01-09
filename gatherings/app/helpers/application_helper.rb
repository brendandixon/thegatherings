module ApplicationHelper

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

end
