require "rails_helper"

class ActiveDatesModel < FauxModel
  include ActiveDates

  define_attributes :active_on, :inactive_on
end

describe ActiveDates, type: :concern do

  before :example do
    @adm = ActiveDatesModel.new
  end

  it 'ensures active_on is set' do
    expect(@adm).to be_valid
    expect(@adm.errors).to_not have_key(:active_on)
  end

  it 'does not ensure active_on for saved records' do
    @adm.save
    @adm.active_on = nil
    expect(@adm).to be_invalid
    expect(@adm.errors).to have_key(:active_on)
  end

  it 'requires an active_on to be on or before today' do
    @adm.active_on = DateTime.current.advance(years: 1)
    expect(@adm).to be_invalid
    expect(@adm.errors).to have_key(:active_on)
  end

  it 'does not require inactive_on' do
    expect(@adm).to be_valid
    expect(@adm.errors).to_not have_key(:inactive_on)
  end

  it 'requires inactive_on to be after active_on' do
    @adm.active_on = 1.year.from_now
    @adm.inactive_on = 1.year.ago
    expect(@adm).to be_invalid
    expect(@adm.errors).to have_key(:inactive_on)
  end

  it 'recognizes activity' do
    @adm.active_on = 1.year.ago
    expect(@adm).to be_active

    @adm.inactive_on = 6.months.ago
    expect(@adm).to be_active(8.months.ago)
    expect(@adm).to_not be_active
  end

end
