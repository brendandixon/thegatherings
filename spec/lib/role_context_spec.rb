require 'rails_helper'

describe RoleContext, type: :lib do

  before :context do
    @community = create(:community)
    @campuses = create_list(:campus, 2, community: @community)

    @assistant = create(:member)
    @leader = create(:member)
    @member = create(:member)
    @overseer = create(:member)
    @visitor = create(:member)
  end

  after :context do
    Campus.delete_all
    Community.delete_all
    Member.delete_all
    Membership.delete_all
  end

  context 'for a Community' do

    before :context do
      RoleContext::COMMUNITY_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'is a community leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_community_leader
      end

      it 'is a community member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_community_member
      end

      it 'is a campus leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is a campus overseer' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_overseer
      end

    end

    context 'Leader' do
      it 'is a community leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_community_leader
      end

      it 'is a community member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_community_member
      end

      it 'is a campus leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is a campus overseer' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_overseer
      end

    end

    context 'Member' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is a community member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_overseer
      end

    end

    context 'Overseer' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_overseer
      end

    end

    context 'Visitor' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_overseer
      end

    end

  end

  context 'for a Campus' do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campuses.first, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is a campus leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is a campus overseer' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_overseer
      end

    end

    context 'Leader' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is a campus leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is a campus overseer' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_overseer
      end

    end

    context 'Member' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_overseer
      end

    end

    context 'Overseer' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is a not campus leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is a campus member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_member
      end

      it 'is a campus overseer' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.first)
        expect(rc).to be_acts_as_campus_overseer
      end

    end

    context 'Visitor' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.first)
        expect(rc).to_not be_acts_as_campus_overseer
      end

    end

  end

  context 'for another Campus' do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campuses.first, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@assistant, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_overseer
      end
    end

    context 'Leader' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@leader, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_overseer
      end
    end

    context 'Member' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@member, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_overseer
      end
    end

    context 'Overseer' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is a not campus leader' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@overseer, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_overseer
      end
    end

    context 'Visitor' do
      it 'is not a community leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_leader
      end

      it 'is not a community member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_community_member
      end

      it 'is not a campus leader' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_leader
      end

      it 'is not a campus member' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_member
      end

      it 'is not a campus overseer' do
        rc = RoleContext.context_for(@visitor, community: @community, campus: @campuses.second)
        expect(rc).to_not be_acts_as_campus_overseer
      end
    end

  end

end
