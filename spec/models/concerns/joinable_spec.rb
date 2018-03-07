require "rails_helper"

describe Joinable, type: :concern do

  before :all do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, campus: @campus)

    @leader = create(:member)
    @assistant = create(:member)
    @member = create(:member)
    @overseer = create(:member)
    @visitor = create(:member)

    @assistants = [@assistant]
    @leaders = [@leader, @assistant]
    @overseers = [@leader, @assistant, @overseer]
    @members = [@leader, @assistant, @overseer, @member]
    @participants = [@leader, @assistant, @member, @overseer, @visitor]
    @visitors = [@visitor]

    ApplicationAuthorizer::roles_allowed_for(@community).each do |role|
      member = self.instance_variable_get("@#{role}")
      create(:membership, "as_#{role}".to_sym, group: @community, member: member)
    end

    ApplicationAuthorizer::roles_allowed_for(@campus).each do |role|
      member = self.instance_variable_get("@#{role}")
      create(:membership, "as_#{role}".to_sym, group: @campus, member: member)
    end

    ApplicationAuthorizer::roles_allowed_for(@gathering).each do |role|
      member = self.instance_variable_get("@#{role}")
      create(:membership, "as_#{role}".to_sym, group: @gathering, member: member)
    end
  end

  after :all do
    Membership.delete_all
    Community.delete_all
    Member.delete_all
  end

  context 'Community' do
    it 'returns the list of assistants' do
      expect(@community.assistants).to match_array(@assistants)
    end

    it 'returns the list of leaders' do
      expect(@community.leaders).to match_array(@leaders)
    end

    it 'returns the list of members' do
      expect(@community.members).to match_array(@members - [@overseer])
    end

    it 'returns the list of overseers' do
      expect(@community.overseers).to be_empty
    end

    it 'returns the list of participants' do
      expect(@community.participants).to match_array(@participants - [@overseer, @visitor])
    end

    it 'returns the list of visitors' do
      expect(@community.visitors).to be_empty
    end
  end

  context 'Campus' do
    it 'returns the list of assistants' do
      expect(@campus.assistants).to match_array(@assistants)
    end

    it 'returns the list of leaders' do
      expect(@campus.leaders).to match_array(@leaders)
    end

    it 'returns the list of members' do
      expect(@campus.members).to match_array(@members)
    end

    it 'returns the list of overseers' do
      expect(@campus.overseers).to match_array(@overseers)
    end

    it 'returns the list of participants' do
      expect(@campus.participants).to match_array(@participants - [@visitor])
    end

    it 'returns the list of visitors' do
      expect(@campus.visitors).to be_empty
    end
  end

  context 'Gathering' do
    it 'returns the list of assistants' do
      expect(@gathering.assistants).to match_array(@assistants)
    end

    it 'returns the list of leaders' do
      expect(@gathering.leaders).to match_array(@leaders)
    end

    it 'returns the list of members' do
      expect(@gathering.members).to match_array(@members - [@overseer])
    end

    it 'returns the list of overseers' do
      expect(@gathering.overseers).to be_empty
    end

    it 'returns the list of participants' do
      expect(@gathering.participants).to match_array(@participants - [@overseer])
    end

    it 'returns the list of visitors' do
      expect(@gathering.visitors).to match_array(@visitors)
    end
  end

end
