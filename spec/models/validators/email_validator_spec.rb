require "rails_helper"

class EmailModel < FauxModel
  define_attributes :email, :email_blank

  validates :email, email: true
  validates :email_blank, email: {allow_blank: true}
end

describe EmailValidator, type: :validator do

  before :example do
    @em = EmailModel.new(email: 'bob.jones@nomail.com', email_blank: 'mary.jones@nomail.com')
  end

  it 'requires an email' do
    @em.email = nil
    expect(@em).to be_invalid
    expect(@em.errors).to have_key(:email)
  end

  it 'rejects an invalid email' do
    @em.email = "bad email"
    expect(@em).to be_invalid
    expect(@em.errors).to have_key(:email)
  end

  it 'accepts a valid email' do
    @em.email = "bob.jone@nomail.com"
    expect(@em).to be_valid
    expect(@em.errors).to_not have_key(:email)
  end

  it 'does not require an email if requested' do
    @em.email_blank = nil
    expect(@em).to be_valid
    expect(@em.errors).to_not have_key(:email_blank)
  end

end
