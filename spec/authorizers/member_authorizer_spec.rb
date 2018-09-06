require 'rails_helper'

describe MemberAuthorizer, type: :authorizer do

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
    @unaffiliated = create(:member)
    @new_member = build(:member)
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
      create(:membership, :as_member, group: @community, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@assistant, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@assistant, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@assistant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@assistant, campus: @campus)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@leader, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@leader, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@leader, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@leader, campus: @campus)
        end
      end
    end

    context 'Member' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@member, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@member, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@member, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@member, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@member, campus: @campus)
        end
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@overseer, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
        end
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@visitor, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
        end
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
        expect(@new_member.authorizer).to be_creatable_by(@assistant, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@assistant, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@assistant, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@assistant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@assistant, campus: @campus)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@leader, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@leader, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@leader, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@leader, campus: @campus)
        end
      end
    end

    context 'Member' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@member, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@member, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@member, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@member, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@member, campus: @campus)
        end
      end
    end

    context 'Overseer' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@overseer, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@overseer, campus: @campus, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@overseer, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@overseer, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@overseer, campus: @campus)
        end
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@visitor, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, campus: @campus, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@visitor, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@visitor, campus: @campus)
        end
      end
    end
  end

  context "for a Gathering" do

    before :context do
      RoleContext::GATHERING_ROLES.each do |role|
        member = self.instance_variable_get("@#{role}")
        create(:membership, "as_#{role}".to_sym, group: @gathering, member: member)
      end
      create(:membership, :as_member, group: @gathering, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, gathering: @gathering)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, gathering: @gathering, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, gathering: @gathering, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@assistant, gathering: @gathering)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@assistant, gathering: @gathering)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, gathering: @gathering)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, gathering: @gathering, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, gathering: @gathering, perspective: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@leader, gathering: @gathering)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@leader, gathering: @gathering)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@leader, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@leader, gathering: @gathering)
        end
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@member, gathering: @gathering)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, gathering: @gathering, perspective: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@member, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@member, gathering: @gathering)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@member, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@member, gathering: @gathering)
        end
      end
    end

    context 'Overseer' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@overseer, gathering: @gathering)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@overseer, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@overseer, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@overseer, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@overseer, gathering: @gathering)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@overseer, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@overseer, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@overseer, gathering: @gathering)
        end
      end
    end

    context 'Visitor' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@visitor, gathering: @gathering)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@visitor, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@visitor, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@visitor, gathering: @gathering)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, gathering: @gathering, perspective: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@visitor, gathering: @gathering, perspective: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@visitor, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@visitor, gathering: @gathering)
        end
      end
    end
  end

  context "for the Member" do
    it 'disallows creation' do
      expect(@unaffiliated.authorizer).to_not be_creatable_by(@unaffiliated)
    end

    it 'allows reading the full profile' do
      expect(@unaffiliated.authorizer).to be_readable_by(@unaffiliated, perspective: :as_member)
    end

    it 'allows reading the public profile' do
      expect(@unaffiliated.authorizer).to be_readable_by(@unaffiliated, perspective: :as_anyone)
    end

    it 'allows updating' do
      expect(@unaffiliated.authorizer).to be_updatable_by(@unaffiliated)
    end

    it 'allows deletion' do
      expect(@unaffiliated.authorizer).to be_deletable_by(@unaffiliated)
    end
  end

end
