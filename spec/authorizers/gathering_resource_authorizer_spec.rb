require 'rails_helper'

describe GatheringResourceAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @assistant = create(:member)
    @leader = create(:member)
    @member = create(:member)
    @overseer = create(:member)
    @visitor = create(:member)

    @affiliated = create(:member)
    @m = create(:meeting, gathering: @gathering)
    @am = create(:membership, group: @gathering, member: @affiliated)
    @ar = build(:attendance_record, meeting: @m, membership: @am)
  end

  after :context do
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

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
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@member)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@member)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Campus" do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end

      @gathering.assigned_overseers.create!(membership: @overseer.memberships.take)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@member)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@member)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@overseer)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@overseer)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@overseer)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      RoleContext::GATHERING_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, :as_member, group: @campus, member: member)
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@ar.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@ar.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@ar.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@member)
      end

      it 'allows reading' do
        expect(@ar.authorizer).to be_readable_by(@member)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@ar.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@ar.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@ar.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@ar.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for an unaffiliated Member" do

    before :context do
      @unaffiliated = create(:member)
    end

    after :context do
      @unaffiliated.delete
    end

    it 'disallows creation' do
      expect(@ar.authorizer).to_not be_creatable_by(@unaffiliated)
    end

    it 'disallows reading' do
      expect(@ar.authorizer).to_not be_readable_by(@unaffiliated)
    end

    it 'disallows updating' do
      expect(@ar.authorizer).to_not be_updatable_by(@unaffiliated)
    end

    it 'disallows deletion' do
      expect(@ar.authorizer).to_not be_deletable_by(@unaffiliated)
    end
  end

end
