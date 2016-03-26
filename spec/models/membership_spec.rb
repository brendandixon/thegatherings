# == Schema Information
#
# Table name: memberships
#
#  id          :integer          not null, primary key
#  member_id   :integer          not null
#  group_id    :integer          not null
#  group_type  :string(255)      not null
#  active_on   :datetime         not null
#  inactive_on :datetime
#  participant :string(25)
#  role        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Membership, type: :model do

  before do
    @member = create(:member)
    @gathering = create(:gathering)
    @membership = build(:membership, :as_member, group: @gathering, member: @member)
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

  context 'Participant and Role' do
    it 'requires either a participant or a role' do
      @membership.participant = nil
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:base)
    end

    it 'allows both a participant and a role' do
      @membership.participant = ApplicationAuthorizer::PARTICIPANT_MEMBER
      @membership.role = :administrator
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:participant)
      expect(@membership.errors).to_not have_key(:role)
    end

    it 'allows all roles for a Community' do
      @membership.group = create(:community)
      ApplicationAuthorizer::roles_for(@membership.group).each do |role|
        @membership.role = role
        expect(@membership).to be_valid
        expect(@membership.errors).to_not have_key(:role)
      end
    end

    it 'rejects anything else for a Community' do
      @membership.group = create(:community)
      @membership.role = 'not a role'
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end

    it 'allows all roles for a Campus' do
      @membership.group = create(:campus)
      ApplicationAuthorizer::roles_for(@membership.group).each do |role|
        @membership.role = role
        expect(@membership).to be_valid
        expect(@membership.errors).to_not have_key(:role)
      end
    end

    it 'rejects anything else for a Campus' do
      @membership.group = create(:campus)
      @membership.role = 'not a role'
      expect(@membership).to be_invalid
      expect(@membership.errors).to have_key(:role)
    end

    it 'allows all roles for a Gathering' do
      @membership.group = create(:gathering)
      ApplicationAuthorizer::roles_for(@membership.group).each do |role|
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

  context 'Visiting' do
    it 'sallows visitors to a Community' do
      @membership.group = create(:community)
      @membership.visit
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:participant)
    end

    it 'disallows visitors to a Campus' do
      @membership.group = create(:campus)
      @membership.visit
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:participant)
    end

    it 'allows visitors to a Gathering' do
      @membership.group = create(:gathering)
      @membership.visit
      expect(@membership).to be_valid
      expect(@membership.errors).to_not have_key(:participant)
    end
  end

end
