# == Schema Information
#
# Table name: request_owners
#
#  id            :bigint(8)        not null, primary key
#  membership_id :bigint(8)        not null
#  request_id    :bigint(8)        not null
#  active_on     :datetime         not null
#  inactive_on   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe RequestOwner, type: :model do

  before :example do
    @owner = build(:request_owner)
  end

  it 'validates' do
    expect(@owner).to be_valid
    expect(@owner.errors).to be_empty
  end

  it 'requires a Request' do
    @owner.request = nil
    expect(@owner).to be_invalid
    expect(@owner.errors).to have_key(:request)
  end

  it 'requires a Membership' do
    @owner.membership = nil
    expect(@owner).to be_invalid
    expect(@owner.errors).to have_key(:membership)
  end

  it 'requires the Membership to be in the Request campus' do
    @owner.membership.group = build(:campus)
    expect(@owner).to be_invalid
    expect(@owner.errors).to have_key(:membership)
  end

  it 'can deactivate and activate' do
    @owner.save!

    expect(@owner).to be_active

    @owner = RequestOwner.deactivate!(@owner.request, @owner.membership)
    expect(@owner).to be_inactive

    @owner = RequestOwner.activate!(@owner.request, @owner.membership)
    expect(@owner).to be_active
  end

end
