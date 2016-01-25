require 'rails_helper'

describe GatheringAuthorizer, type: :authorizer do

  before :context do
    @admin = create(:admin)
    @leader = create(:leader)
    @assistant = create(:assistant)
    @coach = create(:coach)
    @participant = create(:participant)
    @visitor = create(:visitor)

    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)
  end

  after :context do
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

    before :context do
      [:admin, :leader, :assistant, :coach, :participant].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create("community_#{affiliation}", group: @community, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@admin)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@admin)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@admin)
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

    context 'Participant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@participant)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@participant, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@participant)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@participant)
      end
    end
  end

  context "for a Campus" do

    before :context do
      [:admin, :leader, :assistant, :coach, :participant].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:community_participant, group: @community, member: member)
        create("campus_#{affiliation}", group: @campus, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@admin)
      end

      it 'allows reading the leader profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@admin, scope: :as_anyone)
      end

      it 'allows updating' do
        expect(@gathering.authorizer).to be_updatable_by(@admin)
      end

      it 'allows deletion' do
        expect(@gathering.authorizer).to be_deletable_by(@admin)
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

    context 'Participant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@participant)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_leader)
      end

      it 'disallows reading the member profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_member)
      end

      it 'disallows reading the visitor profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@participant, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@participant)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@participant)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      [:leader, :assistant, :coach, :participant, :visitor].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:community_participant, group: @community, member: member)
        create("gathering_#{affiliation}", group: @gathering, member: member)
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

    context 'Participant' do
      it 'allows creation' do
        expect(@gathering.authorizer).to be_creatable_by(@participant)
      end

      it 'disallows reading the leader profile' do
        expect(@gathering.authorizer).to_not be_readable_by(@participant, scope: :as_leader)
      end

      it 'allows reading the member profile' do
        expect(@gathering.authorizer).to be_readable_by(@participant, scope: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@gathering.authorizer).to be_readable_by(@participant, scope: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@gathering.authorizer).to be_readable_by(@participant, scope: :as_anyone)
      end

      it 'disallows updating' do
        expect(@gathering.authorizer).to_not be_updatable_by(@participant)
      end

      it 'disallows deletion' do
        expect(@gathering.authorizer).to_not be_deletable_by(@participant)
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

  context "for a Member" do

    before :context do
      @member = create(:member)
    end

    after :context do
      @member.delete
    end

    it 'disallows creation' do
      expect(@gathering.authorizer).to_not be_creatable_by(@member)
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

    it 'disallows reading the public profile' do
      expect(@gathering.authorizer).to_not be_readable_by(@member, scope: :as_anyone)
    end

    it 'disallows updating' do
      expect(@gathering.authorizer).to_not be_updatable_by(@member)
    end

    it 'disallows deletion' do
      expect(@gathering.authorizer).to_not be_deletable_by(@member)
    end
  end

end
