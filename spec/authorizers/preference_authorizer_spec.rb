require 'rails_helper'

describe PreferenceAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, campus: @campus)

    @assistant = create(:member)
    @leader = create(:member)
    @member = create(:member)
    @overseer = create(:member)
    @visitor = create(:member)

    @affiliated = create(:member)
    @membership = create(:membership, :as_member, group: @community, member: @affiliated)

    @preferences = build(:preference, community: @community, membership: @membership)
  end

  after :context do
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

    before :context do
      RoleContext::COMMUNITY_ROLES.each do |role|
        member = self.instance_variable_get("@#{role}")
        create(:membership, "as_#{role}".to_sym, group: @community, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@assistant, community: @community)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, community: @community)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, community: @community)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, community: @community)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, community: @community)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@leader, community: @community)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, community: @community)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, community: @community)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, community: @community)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, community: @community)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, community: @community)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, community: @community)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, community: @community)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, community: @community)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, community: @community)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, community: @community)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, community: @community)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, community: @community)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, community: @community)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, community: @community)
      end
    end
  end

  context "for a Campus" do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |role|
        member = self.instance_variable_get("@#{role}")
        create(:membership, "as_#{role}".to_sym, group: @campus, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@assistant, campus: @campus)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, campus: @campus)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, campus: @campus)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, campus: @campus)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@leader, campus: @campus)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, campus: @campus)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, campus: @campus)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, campus: @campus)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, campus: @campus)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, campus: @campus)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, campus: @campus)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, campus: @campus)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, campus: @campus)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, campus: @campus)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, campus: @campus)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      RoleContext::GATHERING_ROLES.each do |role|
        member = self.instance_variable_get("@#{role}")
        create(:membership, "as_#{role}".to_sym, group: @gathering, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@assistant, gathering: @gathering)
      end

      it 'disallows reading' do
        expect(@preferences.authorizer).to_not be_readable_by(@assistant, gathering: @gathering)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering)
      end
    end

    context 'Leader' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@leader, gathering: @gathering)
      end

      it 'disallows reading' do
        expect(@preferences.authorizer).to_not be_readable_by(@leader, gathering: @gathering)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@leader, gathering: @gathering)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@leader, gathering: @gathering)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, gathering: @gathering)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, gathering: @gathering)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, gathering: @gathering)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, gathering: @gathering)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, gathering: @gathering)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, gathering: @gathering)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, gathering: @gathering)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, gathering: @gathering)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, gathering: @gathering)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, gathering: @gathering)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, gathering: @gathering)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, gathering: @gathering)
      end
    end
  end

  context "for the Member" do

    before :context do
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    it 'allows creation' do
      expect(@preferences.authorizer).to be_creatable_by(@affiliated)
    end

    it 'allows reading' do
      expect(@preferences.authorizer).to be_readable_by(@affiliated)
    end

    it 'allows updating' do
      expect(@preferences.authorizer).to be_updatable_by(@affiliated)
    end

    it 'allows deletion' do
      expect(@preferences.authorizer).to be_deletable_by(@affiliated)
    end
  end

end
