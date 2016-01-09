require "rails_helper"

class ZoneableModel < FauxModel
  include Zoneable

  define_attributes :time_zone, :other
end

RSpec.describe Zoneable do

  before :example do
    @zm = ZoneableModel.new
  end

  context "when validating" do

    it "only validates time_zone" do
      @zm.time_zone = ActiveSupport::TimeZone.us_zones.first
      expect(@zm).to be_valid
      expect(@zm.errors).to be_empty
    end

    it "requires that the time_zone is present" do
      expect(@zm).to_not be_valid
      expect(@zm.errors).to have_key(:time_zone)
    end

    it "converts the time_zone to a string when saving" do
      @zm.time_zone = ActiveSupport::TimeZone.us_zones.first
      @zm.save
      expect(@zm.saved[:time_zone]).to be_is_a(String)
    end
  
  end

end
