# == Schema Information
#
# Table name: memberships
#
#  id          :bigint(8)        not null, primary key
#  member_id   :bigint(8)        not null
#  group_id    :bigint(8)        unsigned, not null
#  group_type  :string(255)      not null
#  active_on   :datetime         not null
#  inactive_on :datetime
#  role        :string(25)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Membership, type: :model do

  before do
    @member = create(:member)
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, campus: @campus)
    @membership = build(:membership, :as_leader, group: @gathering, member: @member)
  end

  context 'Member and Group Validation' do
    it 'requires a member' do
      @membership.member = nil
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:member)
    end

    it 'requires a group' do
      @membership.group = nil
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:group)
    end

    it 'accepts a Community' do
      @membership.group = create(:community)
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:group)
    end

    it 'accepts a Campus' do
      @membership.group = create(:campus)
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:group)
    end

    it 'accepts a Gathering' do
      @membership.group = create(:gathering)
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:group)
    end

    it 'rejects all other groups' do
      @membership.group = create(:member)
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:group)
    end
  end

  context 'Role' do
    it 'requires a role' do
      @membership.role = nil
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end

    it 'allows all Community roles' do
      @membership.group = @community
      ApplicationAuthorizer::roles_allowed_for(@membership.group).each do |role|
        @membership.role = role
        expect(@membership).to be_valid
        expect(@membership.errors).to_not have_key(:role)
      end
    end

    it 'rejects anything else for a Community' do
      @membership.group = @community
      @membership.role = 'not a role'
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end

    it 'allows all Campus roles' do
      @membership.group = @campus
      ApplicationAuthorizer::roles_allowed_for(@membership.group).each do |role|
        @membership.role = role
        expect(@membership).to be_valid
        expect(@membership.errors).to_not have_key(:role)
      end
    end

    it 'rejects anything else for a Campus' do
      @membership.group = @campus
      @membership.role = 'not a role'
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end

    it 'disallows downgrading Overseers if assigned Gatherings to oversee' do
      @membership.group = @campus
      @membership.role = ApplicationAuthorizer::OVERSEER
      @membership.save!
      overseer = create(:assigned_overseer, gathering: @gathering, membership: @membership)

      @membership.role = ApplicationAuthorizer::MEMBER
      expect(@membership).to_not be_valid
      expect(@membership.errors).to have_key(:role)
    end

    it 'allows all Gathering roles' do
      @membership.group = @gathering
      ApplicationAuthorizer::roles_allowed_for(@membership.group).each do |role|
        @membership.role = role
        expect(@membership).to be_valid
        expect(@membership.errors).to_not have_key(:role)
      end
    end

    it 'rejects anything else for a Gathering' do
      @membership.group = create(:gathering)
      @membership.role = 'not a role'
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end
  end

  it 'recognizes the owning Member' do
    expect(@membership).to be_for(@member)
  end

  it 'rejects other Members' do
    expect(@membership).to_not be_for(build_stubbed(:member))
  end

  it 'recognizes the owning group' do
    expect(@membership).to be_to(@gathering)
  end

  it 'rejects other groups' do
    expect(@membership).to_not be_to(@gathering.community)
  end

end
