require 'rails_helper'

describe GatheringAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @administrator = create(:member)
    @leader = create(:member)
    @assistant = create(:member)
    @coach = create(:member)
    @member = create(:member)
    @visitor = create(:member)
  end

  after :context do
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

    before :context do
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@administrator)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@assistant)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@member)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@member, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@member)
      end
    end
  end

  context "for a Campus" do

    before :context do
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@administrator, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@administrator)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@assistant)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@assistant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@member)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@member, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@member)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      [:leader, :assistant, :coach, :member, :visitor].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, :as_member, group: @community, member: member)
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@leader, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@assistant, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@coach, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@member)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@member, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@member, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@member, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Visitor' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@visitor)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@visitor, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@visitor, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@visitor, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@visitor, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@visitor)
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
      expect(@gathering.authorizer).to_not be_creatable_by(@unaffiliated)
    end

    it 'disallows reading the leader profile' do
      expect(@gathering.authorizer).to_not be_readable_by(@unaffiliated, scope: :as_leader)
    end

    it 'disallows reading the member profile' do
      expect(@gathering.authorizer).to_not be_readable_by(@unaffiliated, scope: :as_member)
    end

    it 'disallows reading the visitor profile' do
      expect(@gathering.authorizer).to_not be_readable_by(@unaffiliated, scope: :as_visitor)
    end

    it 'disallows reading the public profile' do
      expect(@gathering.authorizer).to_not be_readable_by(@unaffiliated, scope: :as_anyone)
    end

    it 'disallows updating' do
      expect(@gathering.authorizer).to_not be_updatable_by(@unaffiliated)
    end

    it 'disallows deletion' do
      expect(@gathering.authorizer).to_not be_deletable_by(@unaffiliated)
    end
  end

end
