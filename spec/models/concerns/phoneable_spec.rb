require "rails_helper"

class PhoneableModel < FauxModel
  include Phoneable

  define_attributes :phone
end

describe Phoneable, type: :concern do

  before :example do
    @pm = PhoneableModel.new
  end

  it 'requires a phone number' do
    @pm.phone = nil
    expect(@pm).to be_invalid
    expect(@pm.errors).to have_key(:phone)
  end

  it 'accepts and normalizes valid phone numbers' do
    [
      '1235551212',
      '123 5551212',
      '123 555 1212',
      '123.555.1212',
      '123-555-1212',
      '123.555-1212',
      '123-555.1212',
      '123 555.1212',
      '123 555-1212',
      '123.555 1212',
      '123-555 1212',
      '123.5551212',
      '123-5551212',
      '(123)555-1212',
      '(123)555.1212',
      '(123) 555-1212',
      '(123) 555.1212',
      '(123)5551212',
      '(123)555 1212',
      '(123) 555 1212'
    ].each do |n|
      @pm.phone = n
      expect(@pm).to be_valid
      expect(@pm.errors).to_not have_key(:phone)
      expect(@pm.phone).to eq('123.555.1212')
    end
  end

end
