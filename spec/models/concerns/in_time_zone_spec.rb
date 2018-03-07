require "rails_helper"

class InTimeZoneModel < TestModelBase
  include InTimeZone

  define_attribute :time_zone, :string
end

describe InTimeZone, type: :concern do

  before :all do
    @tm = InTimeZoneModel.new
  end

  it 'validates' do
    expect(@tm).to be_valid
    expect(@tm.errors).to_not have_key(:time_zone)
  end

  it 'sets a default time zone' do
    @tm.time_zone = nil
    expect(@tm).to be_valid
    expect(@tm.errors).to_not have_key(:time_zone)
  end

  it 'requires a time zone' do
    @tm.time_zone = "something else"
    expect(@tm).to be_invalid
    expect(@tm.errors).to have_key(:time_zone)
  end

  # Note: Tested on Member for now since ActiveModel does not yet fully support type casts
  # it 'converts TimeZone to its name' do
  #   @tm.time_zone = ActiveSupport::TimeZone.all.first
  #   expect(@tm.time_zone).to be_a(String)
  # end

end
