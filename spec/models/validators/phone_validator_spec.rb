require "rails_helper"

class PhoneModel < TestModelBase
  define_attribute :phone, :string

  validates :phone, phone: true
end

describe PhoneValidator, type: :validator do

  before :example do
    @pm = PhoneModel.new
  end

  it 'rejects a malformed phone number' do
    @pm.phone = '12.34.56.78'
    expect(@pm).to be_invalid
    expect(@pm.errors).to have_key(:phone)
  end

end
