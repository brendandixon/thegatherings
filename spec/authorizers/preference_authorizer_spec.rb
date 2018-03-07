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

    @preferences = build(:preference, community: @community, member: @affiliated)
  end

  after :context do
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  context "for a Community" do

    before :context do
      ApplicationAuthorizer::COMMUNITY_ROLES.each do |role|
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

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@assistant, community: @community, context: :as_signup)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, community: @community)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, community: @community, context: :as_signup)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, community: @community)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, community: @community, context: :as_signup)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, community: @community)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, community: @community, context: :as_signup)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, community: @community)
      end

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, community: @community, context: :as_signup)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@leader, community: @community)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@leader, community: @community, context: :as_signup)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, community: @community)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, community: @community, context: :as_signup)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, community: @community)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, community: @community, context: :as_signup)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, community: @community)
      end

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@member, community: @community, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, community: @community)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@member, community: @community, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, community: @community)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@member, community: @community, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, community: @community)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@member, community: @community, context: :as_signup)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, community: @community)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, community: @community, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, community: @community)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, community: @community, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, community: @community)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, community: @community, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, community: @community)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, community: @community, context: :as_signup)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, community: @community)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, community: @community, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, community: @community)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, community: @community, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, community: @community)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, community: @community, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, community: @community)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, community: @community, context: :as_signup)
      end
    end
  end

  context "for a Campus" do

    before :context do
      ApplicationAuthorizer::CAMPUS_ROLES.each do |role|
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

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@assistant, campus: @campus, context: :as_signup)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, campus: @campus)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@assistant, campus: @campus, context: :as_signup)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, campus: @campus)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@assistant, campus: @campus, context: :as_signup)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, campus: @campus)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@assistant, campus: @campus, context: :as_signup)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@leader, campus: @campus, context: :as_signup)
      end

      it 'allows reading' do
        expect(@preferences.authorizer).to be_readable_by(@leader, campus: @campus)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@leader, campus: @campus, context: :as_signup)
      end

      it 'allows updating' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, campus: @campus)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@leader, campus: @campus, context: :as_signup)
      end

      it 'allows deletion' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, campus: @campus)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@leader, campus: @campus, context: :as_signup)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, campus: @campus)
      end

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@member, campus: @campus, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, campus: @campus)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@member, campus: @campus, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, campus: @campus)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@member, campus: @campus, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, campus: @campus)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@member, campus: @campus, context: :as_signup)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, campus: @campus)
      end

      it 'allows creating signups' do
        expect(@preferences.authorizer).to be_creatable_by(@overseer, campus: @campus, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, campus: @campus)
      end

      it 'allows reading signups' do
        expect(@preferences.authorizer).to be_readable_by(@overseer, campus: @campus, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
      end

      it 'allows updating signups' do
        expect(@preferences.authorizer).to be_updatable_by(@overseer, campus: @campus, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
      end

      it 'allows deleting signups' do
        expect(@preferences.authorizer).to be_deletable_by(@overseer, campus: @campus, context: :as_signup)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, campus: @campus)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, campus: @campus, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, campus: @campus)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, campus: @campus, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, campus: @campus, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, campus: @campus, context: :as_signup)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      ApplicationAuthorizer::GATHERING_ROLES.each do |role|
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

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@assistant, gathering: @gathering, context: :as_signup)
      end

      it 'disallows reading' do
        expect(@preferences.authorizer).to_not be_readable_by(@assistant, gathering: @gathering)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@assistant, gathering: @gathering, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering, context: :as_signup)
      end
    end

    context 'Leader' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@leader, gathering: @gathering)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@leader, gathering: @gathering, context: :as_signup)
      end

      it 'disallows reading' do
        expect(@preferences.authorizer).to_not be_readable_by(@leader, gathering: @gathering)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@leader, gathering: @gathering, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@leader, gathering: @gathering)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@leader, gathering: @gathering, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@leader, gathering: @gathering)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@leader, gathering: @gathering, context: :as_signup)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, gathering: @gathering)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@member, gathering: @gathering, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, gathering: @gathering)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@member, gathering: @gathering, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, gathering: @gathering)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@member, gathering: @gathering, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, gathering: @gathering)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@member, gathering: @gathering, context: :as_signup)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, gathering: @gathering)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, gathering: @gathering, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, gathering: @gathering)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@overseer, gathering: @gathering, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, gathering: @gathering)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@overseer, gathering: @gathering, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@overseer, gathering: @gathering)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@overseer, gathering: @gathering, context: :as_signup)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, gathering: @gathering)
      end

      it 'disallows creating signups' do
        expect(@preferences.authorizer).to_not be_creatable_by(@visitor, gathering: @gathering, context: :as_signup)
      end

      it 'disallows reading the preferences' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, gathering: @gathering)
      end

      it 'disallows reading signups' do
        expect(@preferences.authorizer).to_not be_readable_by(@visitor, gathering: @gathering, context: :as_signup)
      end

      it 'disallows updating' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, gathering: @gathering)
      end

      it 'disallows updating signups' do
        expect(@preferences.authorizer).to_not be_updatable_by(@visitor, gathering: @gathering, context: :as_signup)
      end

      it 'disallows deletion' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, gathering: @gathering)
      end

      it 'disallows deleting signups' do
        expect(@preferences.authorizer).to_not be_deletable_by(@visitor, gathering: @gathering, context: :as_signup)
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
