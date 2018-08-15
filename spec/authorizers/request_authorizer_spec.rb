require 'rails_helper'

describe RequestAuthorizer, type: :authorizer do

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
      RoleContext::COMMUNITY_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
      @membership = create(:membership, :as_member, group: @campus, member: @member)
      @affiliate_membership = create(:membership, :as_member, group: @campus, member: @affiliate)
      @request = build(:request, community: @community, campus: @campus, gathering: @gathering, membership: @membership)
    end

    after :context do
      Request.delete_all
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_updatable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_deletable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @request.membership = @affiliate_membership
        end
        
        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'disallows reading' do
          expect(@request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows deletion' do
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  
    context 'Overseer' do
      it 'disallows creation' do
        expect(@request.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@request.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@request.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@request.authorizer).to_not be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Campus" do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |affiliation|
        next if affiliation == RoleContext::MEMBER
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
      @membership = create(:membership, :as_member, group: @campus, member: @member)
      @affiliate_membership = create(:membership, :as_member, group: @campus, member: @affiliate)
      @request = build(:request, community: @community, campus: @campus, gathering: @gathering, membership: @membership)
    end

    after :context do
      Request.delete_all
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_updatable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_deletable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @request.membership = @affiliate_membership
        end
        
        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'disallows reading' do
          expect(@request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows deletion' do
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  
    context 'Overseer' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@overseer)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@overseer)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@overseer)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@overseer)
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
        expect(@request.authorizer).to be_creatable_by(@overseer)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@overseer)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@overseer)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      RoleContext::GATHERING_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
      @membership = create(:membership, :as_member, group: @campus, member: @member)
      @affiliate_membership = create(:membership, :as_member, group: @campus, member: @affiliate)
      @request = build(:request, community: @community, campus: @campus, gathering: @gathering, membership: @membership)
    end

    after :context do
      Request.delete_all
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@request.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@request.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@request.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@request.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      context 'For Self' do

        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_updatable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_updatable_by(@member)
        end

        it 'disallows updating if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows updating if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion if not completed' do
          @request.unanswered!
          expect(@request.authorizer).to be_deletable_by(@member)

          @request.inprocess!
          expect(@request.authorizer).to be_deletable_by(@member)
        end

        it 'disallows deletion if accepted' do
          @request.accepted!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end

        it 'disallows deletion if dismissed' do
          @request.dismissed!
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @request.membership = @affiliate_membership
        end
        
        it 'allows creation' do
          expect(@request.authorizer).to be_creatable_by(@member)
        end

        it 'disallows reading' do
          expect(@request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@request.authorizer).to_not be_updatable_by(@member)
        end

        it 'disallows deletion' do
          expect(@request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  
    context 'Overseer' do
      it 'disallows creation' do
        expect(@request.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading' do
        expect(@request.authorizer).to_not be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@request.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@request.authorizer).to_not be_deletable_by(@overseer)
      end
    end
  
    context 'Visitor' do
      it 'disallows creation' do
        expect(@request.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading' do
        expect(@request.authorizer).to_not be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@request.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@request.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

end
