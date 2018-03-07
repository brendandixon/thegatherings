# == Schema Information
#
# Table name: preferences
#
#  id           :bigint(8)        not null, primary key
#  community_id :bigint(8)
#  member_id    :bigint(8)
#  campus_id    :bigint(8)
#  gathering_id :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe Preference, type: :model do

  before :example do
    @c = create(:community)
    @ca = create(:campus, community: @c)
    @g = create(:gathering, campus: @ca)
    @m = create(:member)
    @cam = create(:membership, group: @ca, member: @m)
    @gm = create(:membership, group: @g, member: @m)
    @p = build(:preference, community: @c, member: @m)
  end

  after :example do
    Community.delete_all
    Member.delete_all
    Preference.delete_all
  end

  it 'validates' do
    expect(@p).to be_valid
    expect(@p.errors).to be_empty
  end

  it 'requires a community' do
    @p.community = nil
    expect(@p).to be_invalid
    expect(@p.errors).to have_key(:community)
  end

  it 'requires a member' do
    @p.member = nil
    expect(@p).to be_invalid
    expect(@p.errors).to have_key(:member)
  end

  it 'allows duplicates across communities' do
    @p.save!
    
    c = create(:community)
    p = create(:preference, community: c, member: @m)
    expect(p).to be_valid
    expect(p.save).to_not be false
  end

  it 'disallows duplicates in a community' do
    @p.save!
    
    p = build(:preference, community: @c, member: @m)
    expect(p).to_not be_valid
    expect(p.save).to be false
  end

  it 'accepts a preferred campus' do
    @p.campus = @ca
    expect(@p).to be_valid
    expect(@p.errors).to_not have_key(:campus)
  end

  it 'accepts a preferred gathering' do
    @p.gathering = @g
    expect(@p).to be_valid
    expect(@p.errors).to_not have_key(:gathering)
  end

end
