require 'rails_helper'

describe CommunityAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @assistant = create(:member)
    @leader = create(:member)
    @member = create(:member)
    @overseer = create(:member)
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
      RoleContext::COMMUNITY_ROLES.each do |role|
        member = self.instance_variable_get("@#{role}")
        create(:membership, "as_#{role}".to_sym, group: @community, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'allows reading the member profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_anyone)
      end

      it 'allows updating' do
        expect(@community.authorizer).to be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@leader)
      end

      it 'allows reading the member profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_anyone)
      end

      it 'allows updating' do
        expect(@community.authorizer).to be_updatable_by(@leader)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@member)
      end

      it 'allows reading the member profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@overseer, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@visitor, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Campus" do

    before :context do
      RoleContext::CAMPUS_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@assistant, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@leader)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@leader, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@leader)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@member)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@member, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@overseer, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@visitor, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      RoleContext::GATHERING_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@assistant, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@assistant, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@leader)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@leader, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@leader, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@leader)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@member)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@member, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@member, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@overseer, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@overseer, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@community.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'disallows reading the member profile' do
        expect(@community.authorizer).to_not be_readable_by(@visitor, perspective: :as_member)
      end

      it 'allows reading the visitor profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_visitor)
      end

      it 'allows reading the public profile' do
        expect(@community.authorizer).to be_readable_by(@visitor, perspective: :as_anyone)
      end

      it 'disallows updating' do
        expect(@community.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@community.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

  context "for a Community-owned resource" do

    before :context do
      RoleContext::COMMUNITY_ROLES.each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end

      @role_name = create(:role_name, community: @community)
      @category = create(:category, community: @community)
      @tag = create(:tag, category: @category)
    end

    after :context do
      Membership.delete_all
      RoleName.delete_all
      Category.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@role_name.authorizer).to be_creatable_by(@assistant)
        expect(@category.authorizer).to be_creatable_by(@assistant)
        expect(@tag.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@role_name.authorizer).to be_readable_by(@assistant)
        expect(@category.authorizer).to be_readable_by(@assistant)
        expect(@tag.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@role_name.authorizer).to be_updatable_by(@assistant)
        expect(@category.authorizer).to be_updatable_by(@assistant)
        expect(@tag.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@role_name.authorizer).to be_deletable_by(@assistant)
        expect(@category.authorizer).to be_deletable_by(@assistant)
        expect(@tag.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@role_name.authorizer).to be_creatable_by(@leader)
        expect(@category.authorizer).to be_creatable_by(@leader)
        expect(@tag.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@role_name.authorizer).to be_readable_by(@leader)
        expect(@category.authorizer).to be_readable_by(@leader)
        expect(@tag.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@role_name.authorizer).to be_updatable_by(@leader)
        expect(@category.authorizer).to be_updatable_by(@leader)
        expect(@tag.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@role_name.authorizer).to be_deletable_by(@leader)
        expect(@category.authorizer).to be_deletable_by(@leader)
        expect(@tag.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@role_name.authorizer).to_not be_creatable_by(@member)
        expect(@category.authorizer).to_not be_creatable_by(@member)
        expect(@tag.authorizer).to_not be_creatable_by(@member)
      end

      it 'allows reading' do
        expect(@role_name.authorizer).to be_readable_by(@member)
        expect(@category.authorizer).to be_readable_by(@member)
        expect(@tag.authorizer).to be_readable_by(@member)
      end

      it 'disallows updating' do
        expect(@role_name.authorizer).to_not be_updatable_by(@member)
        expect(@category.authorizer).to_not be_updatable_by(@member)
        expect(@tag.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@role_name.authorizer).to_not be_deletable_by(@member)
        expect(@category.authorizer).to_not be_deletable_by(@member)
        expect(@tag.authorizer).to_not be_deletable_by(@member)
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@role_name.authorizer).to_not be_creatable_by(@overseer)
        expect(@category.authorizer).to_not be_creatable_by(@overseer)
        expect(@tag.authorizer).to_not be_creatable_by(@overseer)
      end

      it 'allows reading' do
        expect(@role_name.authorizer).to be_readable_by(@overseer)
        expect(@category.authorizer).to be_readable_by(@overseer)
        expect(@tag.authorizer).to be_readable_by(@overseer)
      end

      it 'disallows updating' do
        expect(@role_name.authorizer).to_not be_updatable_by(@overseer)
        expect(@category.authorizer).to_not be_updatable_by(@overseer)
        expect(@tag.authorizer).to_not be_updatable_by(@overseer)
      end

      it 'disallows deletion' do
        expect(@role_name.authorizer).to_not be_deletable_by(@overseer)
        expect(@category.authorizer).to_not be_deletable_by(@overseer)
        expect(@tag.authorizer).to_not be_deletable_by(@overseer)
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@role_name.authorizer).to_not be_creatable_by(@visitor)
        expect(@category.authorizer).to_not be_creatable_by(@visitor)
        expect(@tag.authorizer).to_not be_creatable_by(@visitor)
      end

      it 'allows reading' do
        expect(@role_name.authorizer).to be_readable_by(@visitor)
        expect(@category.authorizer).to be_readable_by(@visitor)
        expect(@tag.authorizer).to be_readable_by(@visitor)
      end

      it 'disallows updating' do
        expect(@role_name.authorizer).to_not be_updatable_by(@visitor)
        expect(@category.authorizer).to_not be_updatable_by(@visitor)
        expect(@tag.authorizer).to_not be_updatable_by(@visitor)
      end

      it 'disallows deletion' do
        expect(@role_name.authorizer).to_not be_deletable_by(@visitor)
        expect(@category.authorizer).to_not be_deletable_by(@visitor)
        expect(@tag.authorizer).to_not be_deletable_by(@visitor)
      end
    end
  end

end
