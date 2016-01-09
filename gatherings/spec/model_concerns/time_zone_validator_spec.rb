require "rails_helper"

class TimeZoneModel < FauxModel
  define_attributes :time_zone, :time_zone_blank, :time_zone_us, :other

  validates :time_zone, time_zone: true
  validates :time_zone_blank, time_zone: {allow_blank: true}
  validates :time_zone_us, time_zone: {allow_blank: true, us_only: true}
end

RSpec.describe TimeZoneValidator do

  before :example do
    @tzm = TimeZoneModel.new
  end

  context "when validating" do

    it "only validates time_zone" do
      expect(@tzm).to_not be_valid
      expect(@tzm.errors).to_not have_key(:other)
    end

    it "will require a time zone" do
      expect(@tzm).to_not be_valid
      expect(@tzm.errors).to have_key(:time_zone)
    end

    it "will accept an ActiveSupport::TimeZone" do
      @tzm.time_zone = ActiveSupport::TimeZone.all.first
      expect(@tzm).to be_valid
    end

    it "will skip validating if blank is allowed" do
      @tzm.time_zone = ActiveSupport::TimeZone.all.first
      expect(@tzm).to be_valid
    end

    it "will disallow anything other than an ActiveSupport::TimeZone" do
      @tzm.time_zone = ActiveSupport::TimeZone.all.first.name
      expect(@tzm).to_not be_valid
      expect(@tzm.errors).to have_key(:time_zone)
    end

    it "will reject a non-US time zone if requested" do
      @tzm.time_zone = ActiveSupport::TimeZone.all.first
      @tzm.time_zone_us = ActiveSupport::TimeZone.all.first
      expect(@tzm).to_not be_valid
      expect(@tzm.errors).to have_key(:time_zone_us)
    end

    it "will accept a US time zone if requested" do
      @tzm.time_zone = ActiveSupport::TimeZone.all.first
      @tzm.time_zone_us = ActiveSupport::TimeZone.us_zones.first
      expect(@tzm).to be_valid
    end
  
  end

end
