require 'rails_helper'

describe MembershipRequestAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @assistant = create(:member)
    @leader = create(:member)
    @member = create(:member)
    @overseer = create(:member)
    @visitor = create(:member)

    @affiliate = create(:member)
  end

  after :context do
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

    before :context do
      ApplicationAuthorizer::COMMUNITY_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliate)
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
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

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
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
  
    context 'Overseer' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Campus" do

    before :context do
      ApplicationAuthorizer::CAMPUS_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliate)
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
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

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
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
  
    context 'Overseer' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@overseer)
      end
    end
  
    context 'assigned Overseer' do

      before :context do
        @gathering.assigned_overseers.create!(membership: @overseer.memberships.take)
      end

      after :context do
        AssignedOverseer.delete_all
      end

      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@overseer)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@overseer)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@overseer)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      ApplicationAuthorizer::GATHERING_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliate)
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
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

    context 'Member' do
      context 'For Self' do

        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @membership_request.unanswer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)

          @membership_request.answer!
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @membership_request.accept!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @membership_request.dismiss!
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
        end
        
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  
    context 'Overseer' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@membership_request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@membership_request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@membership_request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@membership_request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

end
