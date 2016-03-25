require 'rails_helper'

describe MembershipRequestAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @administrator = create(:member)
    @leader = create(:member)
    @assistant = create(:member)
    @coach = create(:member)
    @member = create(:member)

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
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
      create(:membership, :as_member, group: @community, member: @affiliate)
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@administrator)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@administrator)
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

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if unaccepted' do
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

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  end

  context "for a Campus" do

    before :context do
      create(:membership, :as_member, group: @community, member: @member)
      create(:membership, :as_member, group: @community, member: @affiliate)
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
    end

    after :context do
      MembershipRequest.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@membership_request.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading' do
        expect(@membership_request.authorizer).to be_readable_by(@administrator)
      end

      it 'allows updating' do
        expect(@membership_request.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@membership_request.authorizer).to be_deletable_by(@administrator)
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

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if unaccepted' do
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

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  end

  context "for a Gathering" do

    before :context do
      create(:membership, :as_member, group: @community, member: @member)
      create(:membership, :as_member, group: @community, member: @affiliate)
      [:leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
      @membership_request = build(:membership_request, gathering: @gathering, member: @member)
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

    context 'Member' do
      context 'For Self' do
        it 'allows creation' do
          expect(@membership_request.authorizer).to be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to be_readable_by(@member)
        end

        it 'allows updating if unaccepted' do
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

        it 'allows deletion' do
          expect(@membership_request.authorizer).to be_deletable_by(@member)
        end
      end

      context 'For Others' do
        before do
          @membership_request.member = @affiliate
        end
        
        it 'disallows creation' do
          expect(@membership_request.authorizer).to_not be_creatable_by(@member)
        end

        it 'allows reading' do
          expect(@membership_request.authorizer).to_not be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@membership_request.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@membership_request.authorizer).to_not be_deletable_by(@member)
        end
      end
    end
  end

  context "for a Member" do

    before :context do
      create(:membership, :as_member, group: @gathering, member: @member)
      @membership_request = build(:membership_request, gathering: @gathering, member: @affiliate)
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
