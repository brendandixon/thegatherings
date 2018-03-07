# == Schema Information
#
# Table name: assigned_overseers
#
#  id            :bigint(8)        not null, primary key
#  membership_id :bigint(8)        not null
#  gathering_id  :bigint(8)        not null
#  active_on     :datetime         not null
#  inactive_on   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe AssignedOverseer, type: :model do

  before :example do
    @overseer = build(:assigned_overseer)
  end

  it 'validates' do
    expect(@overseer).to be_valid
    expect(@overseer.errors).to be_empty
  end

  it 'requires a Gathering' do
    @overseer.gathering = nil
    expect(@overseer).to be_invalid
    expect(@overseer.errors).to have_key(:gathering)
  end

  it 'requires a Membership' do
    @overseer.membership = nil
    expect(@overseer).to be_invalid
    expect(@overseer.errors).to have_key(:membership)
  end

  it 'requires the Membership to be in the Gathering campus' do
    @overseer.membership.group = build(:campus)
    expect(@overseer).to be_invalid
    expect(@overseer.errors).to have_key(:membership)
  end

  it 'can deactivate and activate' do
    @overseer.save!

    expect(@overseer).to be_active

    @overseer = AssignedOverseer.deactivate!(@overseer.gathering, @overseer.membership)
    expect(@overseer).to be_inactive

    @overseer = AssignedOverseer.activate!(@overseer.gathering, @overseer.membership)
    expect(@overseer).to be_active
  end

end
