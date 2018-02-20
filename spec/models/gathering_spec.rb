# == Schema Information
#
# Table name: gatherings
#
#  id               :integer          not null, primary key
#  community_id     :integer          not null
#  name             :string(255)
#  description      :text(65535)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  postal_code      :string(255)
#  country          :string(255)
#  time_zone        :string(255)
#  meeting_starts   :datetime
#  meeting_ends     :datetime
#  meeting_day      :integer
#  meeting_time     :integer
#  meeting_duration :integer
#  childcare        :boolean          default(FALSE), not null
#  childfriendly    :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  minimum          :integer
#  maximum          :integer
#  open             :boolean          default(TRUE), not null
#  campus_id        :integer
#

require 'rails_helper'

describe Gathering, type: :model do

  before do
    Time.use_zone(TheGatherings::Application.default_time_zone) do
      @gathering = build(:gathering)
    end
  end

  context 'Basic Validation' do
    it 'requires a Community' do
      @gathering.community = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:community)
    end

    it 'does not require a campus' do
      @gathering.campus = nil
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:campus)
    end

    it 'accepts a campus' do
      @gathering.campus = build(:campus)
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:campus)
    end

    it 'requires a minimum number of members' do
      @gathering.minimum = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:minimum)
    end

    it 'requires that the minimum number of members be reasonable' do
      @gathering.minimum = 1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:minimum)
    end

    it 'accepts a reasonable minimum number of members' do
      @gathering.minimum = 1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:minimum)
    end

    it 'requires a maximum number of members' do
      @gathering.maximum = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:maximum)
    end

    it 'requires that the maximum number of members be reasonable' do
      @gathering.maximum = 1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:maximum)
    end

    it 'accepts a reasonable maximum number of members' do
      @gathering.maximum = 1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:maximum)
    end

    it 'expects the minimum number of members to be no greater than the maximum' do
      @gathering.minimum = 10
      @gathering.maximum = 5
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:minimum)
      expect(@gathering.errors).to have_key(:maximum)
    end
  end

  context 'Name and Description Validation' do
    it 'requires a name' do
      @gathering.name = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:name)
    end

    it 'rejects short names' do
      @gathering.name = "short"
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:name)
    end

    it 'rejects excessively long names' do
      @gathering.name = "x" * 256
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:name)
    end

    it 'requires a description' do
      @gathering.description = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:description)
    end

    it 'rejects short descriptions' do
      @gathering.description = "short"
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:description)
    end

    it 'rejects excessively long descriptions' do
      @gathering.description = "x" * 5000
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:description)
    end
  end

  context 'Meeting Validation' do
    it 'requires a meeting start date' do
      @gathering.meeting_starts = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_starts)
    end

    it 'accepts a future meeting start date' do
      @gathering.meeting_starts = 1.year.from_now
      @gathering.meeting_ends = 2.years.from_now
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:meeting_starts)
    end

    it 'accepts a past meeting start date' do
      @gathering.meeting_starts = 1.year.ago
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:meeting_starts)
    end

    it 'requires a valid meeting start date' do
      @gathering.meeting_starts = "foo bar bad date"
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_starts)
    end

    it 'does not require a meeting end date' do
      @gathering.meeting_ends = nil
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:meeting_ends)
    end

    it 'requires that the meeting end date is after the meeting start date' do
      @gathering.meeting_starts = 1.day.from_now
      @gathering.meeting_ends = 1.day.ago
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to_not have_key(:meeting_starts)
      expect(@gathering.errors).to have_key(:meeting_ends)
    end

    it 'requires a meeting day' do
      @gathering.meeting_day = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_day)
    end

    it 'accepts a valid meeting day' do
      @gathering.meeting_day = 4
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:meeting_day)
    end

    it 'requires a numeric meeting day' do
      @gathering.meeting_day = "not really a day name"
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_day)
    end

    it 'rejects meeting days less than zero (Monday)' do
      @gathering.meeting_day = -1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_day)
    end

    it 'rejects meeting days greater than six (Sunday)' do
      @gathering.meeting_day = 7
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_day)
    end

    it 'requires a meeting time' do
      @gathering.meeting_time = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_time)
    end

    it 'accepts a valid meeting time' do
      @gathering.meeting_time = 17.hours
      expect(@gathering).to be_valid
      expect(@gathering.errors).to_not have_key(:meeting_time)
    end

    it 'rejects a meeting time below zero' do
      @gathering.meeting_time = -1
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_time)
    end

    it 'rejects a meeting time longer than one day' do
      @gathering.meeting_time = 24.hours
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_time)
    end

    it 'requires a valid meeting time' do
      @gathering.meeting_time = "this is not a datetime"
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_time)
    end

    it 'requires a meeting duration' do
      @gathering.meeting_duration = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_duration)
    end

    it 'requires meeting durations greater than zero' do
      @gathering.meeting_duration = nil
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_duration)
    end

    it 'requires meeting durations that are whole numbers' do
      @gathering.meeting_duration = 13.5
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_duration)
    end

    it 'requires meeting durations that are less than 24 hours' do
      @gathering.meeting_duration = 25.hours
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_duration)
    end

    it 'requires meeting durations of at least 30 minutes' do
      @gathering.meeting_duration = 20.minutes
      expect(@gathering).to be_invalid
      expect(@gathering.errors).to have_key(:meeting_duration)
    end
  end

  context 'Meeting Time Calculations' do

    before do
      Time.use_zone(@gathering.time_zone) do
        @start_date = Time.zone.local(2015, 2, 1)
        @end_date = @start_date.years_since(2)
        
        @first_meeting = Time.zone.local(2015, 2, 4, 19, 0, 0)
        @today = @start_date.weeks_since(4)
        @next_meeting = Time.zone.local(2015, 3, 4, 19, 0, 0)
        @next_meetings = [@next_meeting, @next_meeting.weeks_since(1), @next_meeting.weeks_since(2), @next_meeting.weeks_since(3)]
        @prior_meeting = Time.zone.local(2015, 2, 25, 19, 0, 0)
        @prior_meetings = [@prior_meeting, @prior_meeting.weeks_ago(1), @prior_meeting.weeks_ago(2), @prior_meeting.weeks_ago(3)]
        @last_meeting = Time.zone.local(2017, 2, 1, 19, 0, 0)
        
        @gathering.meeting_starts = @start_date
        @gathering.meeting_ends = @end_date
        @gathering.meeting_day = 2
        @gathering.meeting_time = 19.hours
      end
    end

    it 'recognizes its own start date' do
      expect(@gathering).to be_started_by(@start_date.beginning_of_day)
    end

    it 'recognizes a valid started by dates' do
      expect(@gathering).to be_started_by(@start_date.days_since(1))
    end

    it 'rejects earlier started by dates' do
      expect(@gathering).to_not be_started_by(@start_date.days_ago(1))
    end

    it 'recognizes a valid ended by date' do
      expect(@gathering).to be_ended_by(@end_date.end_of_day)
    end

    it 'rejects earlier ended by dates' do
      expect(@gathering).to_not be_ended_by(@end_date.days_ago(1))
    end

    it 'correctly returns the first meeting' do
      expect(@gathering.first_meeting).to eq(@first_meeting)
    end

    it 'correctly returns the next meeting' do
      expect(@gathering.next_meeting(@today)).to eq(@next_meeting)
    end

    it 'correctly returns the next several meetings' do
      expect(@gathering.next_meetings(@today, 4)).to match_array(@next_meetings)
    end

    it 'correctly returns the prior meeting' do
      expect(@gathering.prior_meeting(@today)).to eq(@prior_meeting)
    end

    it 'correctly returns the prior several meetings' do
      expect(@gathering.prior_meetings(@today, 4)).to match_array(@prior_meetings)
    end

    it 'correctly returns the last meeting' do
      expect(@gathering.last_meeting).to eq(@last_meeting)
    end

    it 'accepts dates that are a meeting day' do
      expect(@gathering).to be_meeting_on(@next_meeting)
    end

    it 'rejects dates that are not a meeting day' do
      expect(@gathering).to_not be_meeting_on(@next_meeting.tomorrow)
    end

  end

end
