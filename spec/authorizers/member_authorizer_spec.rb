require 'rails_helper'

describe MemberAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @member = create(:member)
    @new_member = build(:member)

    @admin = create(:admin)
    @leader = create(:leader)
    @assistant = create(:assistant)
    @coach = create(:coach)
    @participant = create(:participant)
  end

  after :context do
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
        expect(@new_member.authorizer).to be_creatable_by(@admin, community: @community)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:community_participant, group: @community, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@admin, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@admin, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@admin, community: @community)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@admin, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@admin, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@admin, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@admin, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@admin, community: @community)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, community: @community)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:community_participant, group: @community, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@leader, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@leader, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@leader, community: @community)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@leader, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@leader, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@leader, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@leader, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@leader, community: @community)
        end
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, community: @community)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:community_participant, group: @community, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@assistant, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@assistant, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@assistant, community: @community)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@assistant, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@assistant, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@assistant, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@assistant, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@assistant, community: @community)
        end
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@coach, community: @community)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:community_participant, group: @community, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@coach, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@coach, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@coach, community: @community)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@coach, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@coach, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@coach, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@coach, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@coach, community: @community)
        end
      end
    end

    context 'Participant' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@participant, community: @community)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:community_participant, group: @community, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@participant, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@participant, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@participant, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@participant, community: @community)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@participant, community: @community)
        end
      end
    end
  end

  context "for a Campus" do

    before :context do
      [:admin, :leader, :assistant, :coach, :participant].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create("campus_#{affiliation}", group: @campus, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@admin, campus: @campus)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:campus_participant, group: @campus, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@admin, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@admin, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@admin, campus: @campus)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@admin, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@admin, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@admin, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@admin, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@admin, campus: @campus)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:campus_participant, group: @campus, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@leader, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@leader, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@leader, campus: @campus)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@leader, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@leader, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@leader, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@leader, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@leader, campus: @campus)
        end
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, campus: @campus)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:campus_participant, group: @campus, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@assistant, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@assistant, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@assistant, campus: @campus)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@assistant, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@assistant, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@assistant, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@assistant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@assistant, campus: @campus)
        end
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@coach, campus: @campus)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:campus_participant, group: @campus, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'allows reading the full profile' do
          expect(@member.authorizer).to be_readable_by(@coach, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@coach, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@member.authorizer).to be_updatable_by(@coach, campus: @campus)
        end

        it 'allows deletion' do
          expect(@member.authorizer).to be_deletable_by(@coach, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@coach, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@coach, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@coach, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@coach, campus: @campus)
        end
      end
    end

    context 'Participant' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@participant, campus: @campus)
      end

      context 'with affiliated Members' do

        before :context do
          @membership = create(:campus_participant, group: @campus, member: @member)
        end

        after :context do
          @membership.delete
        end
        
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@member.authorizer).to be_readable_by(@participant, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@participant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@participant, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@member.authorizer).to_not be_readable_by(@participant, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@member.authorizer).to_not be_updatable_by(@participant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@member.authorizer).to_not be_deletable_by(@participant, campus: @campus)
        end
      end
    end
  end

  context "for the Member" do
    it 'disallows creation' do
      expect(@member.authorizer).to_not be_creatable_by(@member)
    end

    it 'allows reading the full profile' do
      expect(@member.authorizer).to be_readable_by(@member, scope: :as_member)
    end

    it 'allows reading the public profile' do
      expect(@member.authorizer).to be_readable_by(@member, scope: :as_anyone)
    end

    it 'allows updating' do
      expect(@member.authorizer).to be_updatable_by(@member)
    end

    it 'allows deletion' do
      expect(@member.authorizer).to be_deletable_by(@member)
    end
  end

end
