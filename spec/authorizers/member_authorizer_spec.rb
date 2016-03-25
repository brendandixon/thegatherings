require 'rails_helper'

describe MemberAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)

    @administrator = create(:member)
    @leader = create(:member)
    @assistant = create(:member)
    @coach = create(:member)
    @member = create(:member)

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
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
      end
      create(:membership, :as_member, group: @community, member: @affiliated)
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@administrator, community: @community)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@administrator, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@administrator, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@administrator, community: @community)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@administrator, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@administrator, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@administrator, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@administrator, community: @community)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@administrator, community: @community)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, community: @community)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@leader, community: @community)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@leader, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@leader, community: @community)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@leader, community: @community)
        end
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, community: @community)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@assistant, community: @community)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@assistant, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@assistant, community: @community)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@assistant, community: @community)
        end
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@coach, community: @community)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@coach, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@coach, community: @community, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@coach, community: @community)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@coach, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@coach, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@coach, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@coach, community: @community)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@coach, community: @community)
        end
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@member, community: @community)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@member, community: @community, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@affiliated.authorizer).to_not be_updatable_by(@member, community: @community)
        end

        it 'disallows deletion' do
          expect(@affiliated.authorizer).to_not be_deletable_by(@member, community: @community)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, community: @community, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, community: @community, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@member, community: @community)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@member, community: @community)
        end
      end
    end
  end

  context "for a Campus" do

    before :context do
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
      create(:membership, :as_member, group: @community, member: @affiliated)
      create(:membership, :as_member, group: @campus, member: @affiliated)
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@administrator, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@administrator, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@administrator, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@administrator, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@administrator, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@administrator, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@administrator, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@administrator, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@administrator, campus: @campus)
        end
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@leader, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@leader, campus: @campus, scope: :as_anyone)
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
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@leader, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@leader, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@leader, campus: @campus)
        end
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@assistant, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@assistant, campus: @campus, scope: :as_anyone)
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
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@assistant, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@assistant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@assistant, campus: @campus)
        end
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@new_member.authorizer).to be_creatable_by(@coach, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'allows reading the full profile' do
          expect(@affiliated.authorizer).to be_readable_by(@coach, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@coach, campus: @campus, scope: :as_anyone)
        end

        it 'allows updating' do
          expect(@affiliated.authorizer).to be_updatable_by(@coach, campus: @campus)
        end

        it 'allows deletion' do
          expect(@affiliated.authorizer).to be_deletable_by(@coach, campus: @campus)
        end
      end

      context 'with unaffiliated Members' do
        it 'disallows reading the full profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@coach, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@coach, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@coach, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@coach, campus: @campus)
        end
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@new_member.authorizer).to_not be_creatable_by(@member, campus: @campus)
      end

      context 'with affiliated Members' do
        it 'disallows reading the full profile' do
          expect(@affiliated.authorizer).to_not be_readable_by(@member, campus: @campus, scope: :as_member)
        end

        it 'allows reading the public profile' do
          expect(@affiliated.authorizer).to be_readable_by(@member, campus: @campus, scope: :as_anyone)
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
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, scope: :as_member)
        end

        it 'disallows reading the public profile' do
          expect(@unaffiliated.authorizer).to_not be_readable_by(@member, campus: @campus, scope: :as_anyone)
        end

        it 'disallows updating' do
          expect(@unaffiliated.authorizer).to_not be_updatable_by(@member, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@unaffiliated.authorizer).to_not be_deletable_by(@member, campus: @campus)
        end
      end
    end
  end

  context "for the Member" do
    it 'disallows creation' do
      expect(@unaffiliated.authorizer).to_not be_creatable_by(@unaffiliated)
    end

    it 'allows reading the full profile' do
      expect(@unaffiliated.authorizer).to be_readable_by(@unaffiliated, scope: :as_member)
    end

    it 'allows reading the public profile' do
      expect(@unaffiliated.authorizer).to be_readable_by(@unaffiliated, scope: :as_anyone)
    end

    it 'allows updating' do
      expect(@unaffiliated.authorizer).to be_updatable_by(@unaffiliated)
    end

    it 'allows deletion' do
      expect(@unaffiliated.authorizer).to be_deletable_by(@unaffiliated)
    end
  end

end
