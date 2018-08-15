module Reports
  extend ActiveSupport::Concern

  include Reports::Attendance
  include Reports::Gap
end
