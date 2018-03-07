# == Schema Information
#
# Table name: role_names
#
#  id           :bigint(8)        not null, primary key
#  community_id :bigint(8)
#  group_type   :string(255)      not null
#  role         :string(255)
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe RoleName, type: :model do

  before :example do
    @rn = build(:role_name)
    @rn.community.role_names.delete_all
  end

  it 'validates' do
    expect(@rn).to be_valid
    expect(@rn.errors).to be_empty
  end

  it 'requires a community' do
    @rn.community = nil
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:community)
  end

  it 'requires a group type' do
    @rn.group_type = nil
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:group_type)
  end

  it 'accepts Community, Campus, and Gathering group types' do
    ApplicationHelper::GROUP_TYPES.each do |gt|
      @rn.group_type = gt
      expect(@rn).to be_valid
      expect(@rn.errors).to be_empty
    end
  end

  it 'rejects all other group types' do
    @rn.group_type = "UnknownGroup"
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:group_type)
  end

  it 'accepts known roles' do
    ApplicationAuthorizer::ROLES.each do |role|
      @rn.role = role
      expect(@rn).to be_valid
      expect(@rn.errors).to be_empty
    end
  end

  it 'rejects any other role' do
    @rn.role = "unknown-role"
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:role)
  end

  it 'requires a name' do
    @rn.name = nil
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:name)
  end

  it 'rejects short names' do
    @rn.name = 'foo'
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:name)
  end

  it 'rejects long names' do
    @rn.name = 'x' * 500
    expect(@rn).to be_invalid
    expect(@rn.errors).to have_key(:name)
  end

  it 'allows one name per role and group type' do
    @rn.save!

    rn = build(:role_name, community: @rn.community)
    expect(rn).to be_invalid
    expect(rn.errors).to have_key(:name)
  end

  it 'allows duplicate names across roles' do
    @rn.save!

    ApplicationAuthorizer::ROLES.each do |role|
      next if role == @rn.role

      rn = build(:role_name, community: @rn.community, role: role)
      expect(rn).to be_valid
      expect(rn.errors).to be_empty
    end
  end

  it 'allows duplicate names across group types' do
    @rn.save!

    ApplicationHelper::GROUP_TYPES.each do |gt|
      next if @rn.group_type == gt
      rn = build(:role_name, community: @rn.community, group_type: gt)
      expect(rn).to be_valid
      expect(rn.errors).to be_empty
    end
  end

  it 'allows duplicate names across communities' do
    @rn.save!

    rn = build(:role_name)
    rn.community.role_names.delete_all

    expect(@rn.community).to_not be(rn.community)
    expect(rn).to be_valid
    expect(rn.errors).to be_empty
  end

end
