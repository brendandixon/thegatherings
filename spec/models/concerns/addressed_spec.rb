require 'rails_helper'

class AddressedModel < TestModelBase
  include Addressed

  define_attribute :street_primary, :string
  define_attribute :street_secondary, :string
  define_attribute :city, :string
  define_attribute :state, :string
  define_attribute :country, :string
  define_attribute :postal_code, :string
end

describe Addressed, type: :concern do

  before :example do
    @am = AddressedModel.new
    @am.street_primary = "123 Some Street"
    @am.city = "Nowhere"
    @am.state = "WA"
    @am.country = "US"
    @am.postal_code = "12345"
  end

  it 'validates' do
    expect(@am).to be_valid
  end

  it 'requires a street' do
    @am.street_primary = nil
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:street_primary)
  end

  it 'rejects a too short street' do
    @am.street_primary = "x" * 2
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:street_primary)
  end

  it 'rejects a too long street' do
    @am.street_primary = "x" * 256
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:street_primary)
  end

  it 'requires a city' do
    @am.city = nil
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:city)
  end

  it 'rejects a too short city' do
    @am.city = "x"
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:city)
  end

  it 'rejects a too long city' do
    @am.city = "x" * 256
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:city)
  end

  it 'requires a state' do
    @am.state = nil
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:state)
  end

  it 'rejects a too short state' do
    @am.state = "x"
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:state)
  end

  it 'rejects a too long state' do
    @am.state = "xxx"
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:state)
  end

  it 'ensures a country' do
    @am.country = nil
    expect(@am).to be_valid
    expect(@am.errors).to_not have_key(:country)
  end

  it 'rejects a too short country' do
    @am.country = "x"
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:country)
  end

  it 'rejects a too long country' do
    @am.country = "x" * 11
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:country)
  end

  it 'requires a postal code' do
    @am.postal_code = nil
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:postal_code)
  end

  it 'rejects non-US postal codes for US addresses' do
    @am.postal_code = 'ABC123'
    expect(@am).to be_invalid
    expect(@am.errors).to have_key(:postal_code)
  end

  it 'accepts US postal codes for US addresses' do
    @am.postal_code = '98117'
    expect(@am).to be_valid
    expect(@am.errors).to_not have_key(:postal_code)
  end

end
