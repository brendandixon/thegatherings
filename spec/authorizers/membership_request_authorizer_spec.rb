require 'rails_helper'

describe MembershipRequestAuthorizer, type: :authorizer do

  before :context do
    @admin = create(:admin)
    @leader = create(:leader)
    @assistant = create(:assistant)
    @coach = create(:coach)
    @participant = create(:participant)
    @member = create(:member)

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
      create(:community_membership, group: @community, member: @member)
      @membership_request = build(:membership_request, gathering: @gathering, member: @participant)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@admin)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@admin)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@admin)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@admin)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@assistant)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Participant' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@participant)
        end

        it 'allows updating if unaccepted' do
          expect(@membership_request.authorizer).to be_updatable_by(@participant)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@participant)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @member
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@participant)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@participant)
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
      create(:community_membership, group: @community, member: @participant)
      create(:community_membership, group: @community, member: @member)
      @membership_request = build(:membership_request, gathering: @gathering, member: @participant)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@admin)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@admin)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@admin)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@admin)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@assistant)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Participant' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@participant)
        end

        it 'allows updating if unaccepted' do
          expect(@membership_request.authorizer).to be_updatable_by(@participant)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@participant)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @member
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@participant)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@participant)
        end
      end
    end
  end

  context "for a Gathering" do

    before :context do
      [:leader, :assistant, :coach, :participant].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create("gathering_#{affiliation}", group: @gathering, member: member)
      end
      create(:community_membership, group: @community, member: @participant)
      create(:community_membership, group: @community, member: @member)
      @membership_request = build(:membership_request, gathering: @gathering, member: @participant)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Participant' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@participant)
        end

        it 'allows updating if unaccepted' do
          expect(@membership_request.authorizer).to be_updatable_by(@participant)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@participant)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @member
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@participant)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@participant)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@participant)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@participant)
        end
      end
    end
  end

  context "for a Member" do

    before :context do
      create(:gathering_participant, group: @gathering, member: @participant)
      @membership_request = build(:membership_request, gathering: @gathering, member: @participant)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    it 'disallows creation' do
      expect(@membership_request.authorizer).to_not be_creatable_by(@member)
    end

    it 'disallows reading' do
      expect(@membership_request.authorizer).to_not be_readable_by(@member)
    end

    it 'disallows updating' do
      expect(@membership_request.authorizer).to_not be_updatable_by(@member)
    end

    it 'disallows deletion' do
      expect(@membership_request.authorizer).to_not be_deletable_by(@member)
    end
  end

end
