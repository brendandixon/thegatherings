require 'rails_helper'

describe MembershipAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @admin = create(:admin)
    @leader = create(:leader)
    @assistant = create(:assistant)
    @coach = create(:coach)
    @participant = create(:participant)

    @member = create(:member)
    @join_community = build(:community_membership, group: @community, member: @member)
    @join_campus = build(:campus_membership, group: @campus, member: @member)
    @join_gathering = build(:gathering_membership, group: @gathering, member: @member)
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
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@admin, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@admin, community: @community)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@admin, community: @community)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@admin, community: @community)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@admin, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@admin, community: @community)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@admin, community: @community)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@admin, community: @community)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@admin, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@admin, community: @community)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@admin, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@admin, community: @community)
        end
      end
    end

    context 'Leader' do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@leader, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@leader, community: @community)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@leader, community: @community)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@leader, community: @community)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@leader, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@leader, community: @community)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@leader, community: @community)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@leader, community: @community)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@leader, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@leader, community: @community)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@leader, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@leader, community: @community)
        end
      end
    end

    context 'Assistant' do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@assistant, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@assistant, community: @community)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@assistant, community: @community)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@assistant, community: @community)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@assistant, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@assistant, community: @community)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@assistant, community: @community)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@assistant, community: @community)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@assistant, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@assistant, community: @community)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@assistant, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@assistant, community: @community)
        end
      end
    end

    context 'Coach' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@coach, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@coach, community: @community)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@coach, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@coach, community: @community)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@coach, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@coach, community: @community)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@coach, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@coach, community: @community)
        end
      end

      context 'with a Gathering Membership' do
        it 'allows creation' do
          expect(@join_gathering.authorizer).to be_creatable_by(@coach, community: @community)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@coach, community: @community)
        end

        it 'allows updating' do
          expect(@join_gathering.authorizer).to be_updatable_by(@coach, community: @community)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@coach, community: @community)
        end
      end
    end

    context 'Participant' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@participant, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@participant, community: @community)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@participant, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@participant, community: @community)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@participant, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@participant, community: @community)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@participant, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@participant, community: @community)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@participant, community: @community)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@participant, community: @community)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@participant, community: @community)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@participant, community: @community)
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
      @membership = build(:campus_membership, group: @campus, member: @member)
    end

    after :context do
      Membership.delete_all
    end

    context 'Administrator' do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@admin, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@admin, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@admin, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@admin, campus: @campus)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@admin, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@admin, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@admin, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@admin, campus: @campus)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@admin, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@admin, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@admin, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@admin, campus: @campus)
        end
      end
    end

    context 'Leader' do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@leader, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@leader, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@leader, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@leader, campus: @campus)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@leader, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@leader, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@leader, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@leader, campus: @campus)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@leader, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@leader, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@leader, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@leader, campus: @campus)
        end
      end
    end

    context 'Assistant' do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@assistant, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@assistant, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@assistant, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@assistant, campus: @campus)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@assistant, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@assistant, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@assistant, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@assistant, campus: @campus)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@assistant, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@assistant, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@assistant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@assistant, campus: @campus)
        end
      end
    end

    context 'Coach' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@coach, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@coach, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@coach, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@coach, campus: @campus)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@coach, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@coach, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@coach, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@coach, campus: @campus)
        end
      end

      context 'with a Gathering Membership' do
        it 'allows creation' do
          expect(@join_gathering.authorizer).to be_creatable_by(@coach, campus: @campus)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@coach, campus: @campus)
        end

        it 'allows updating' do
          expect(@join_gathering.authorizer).to be_updatable_by(@coach, campus: @campus)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@coach, campus: @campus)
        end
      end
    end

    context 'Participant' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@participant, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@participant, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@participant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@participant, campus: @campus)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@participant, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@participant, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@participant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@participant, campus: @campus)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@participant, campus: @campus)
        end
        
        it 'disallows reading' do
          expect(@join_gathering.authorizer).to_not be_readable_by(@participant, campus: @campus)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@participant, campus: @campus)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@participant, campus: @campus)
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
      @membership = build(:gathering_membership, group: @gathering, member: @member)
    end

    after :context do
      Membership.delete_all
    end

    context 'Leader' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@leader, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@leader, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@leader, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@leader, gathering: @gathering)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@leader, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@leader, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@leader, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@leader, gathering: @gathering)
        end
      end

      context 'with a Gathering Membership' do
        it 'allows creation' do
          expect(@join_gathering.authorizer).to be_creatable_by(@leader, gathering: @gathering)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@leader, gathering: @gathering)
        end

        it 'allows updating' do
          expect(@join_gathering.authorizer).to be_updatable_by(@leader, gathering: @gathering)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@leader, gathering: @gathering)
        end
      end
    end

    context 'Assistant' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@assistant, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@assistant, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@assistant, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@assistant, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@assistant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@assistant, gathering: @gathering)
        end
      end

      context 'with a Gathering Membership' do
        it 'allows creation' do
          expect(@join_gathering.authorizer).to be_creatable_by(@assistant, gathering: @gathering)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@assistant, gathering: @gathering)
        end

        it 'allows updating' do
          expect(@join_gathering.authorizer).to be_updatable_by(@assistant, gathering: @gathering)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@assistant, gathering: @gathering)
        end
      end
    end

    context 'Coach' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@coach, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@coach, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@coach, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@coach, gathering: @gathering)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@coach, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@coach, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@coach, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@coach, gathering: @gathering)
        end
      end

      context 'with a Gathering Membership' do
        it 'allows creation' do
          expect(@join_gathering.authorizer).to be_creatable_by(@coach, gathering: @gathering)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@coach, gathering: @gathering)
        end

        it 'allows updating' do
          expect(@join_gathering.authorizer).to be_updatable_by(@coach, gathering: @gathering)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@coach, gathering: @gathering)
        end
      end
    end

    context 'Participant' do
      context 'with a Community Membership' do
        it 'disallows creation' do
          expect(@join_community.authorizer).to_not be_creatable_by(@participant, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_community.authorizer).to_not be_readable_by(@participant, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_community.authorizer).to_not be_updatable_by(@participant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_community.authorizer).to_not be_deletable_by(@participant, gathering: @gathering)
        end
      end

      context 'with a Campus Membership' do
        it 'disallows creation' do
          expect(@join_campus.authorizer).to_not be_creatable_by(@participant, gathering: @gathering)
        end
        
        it 'disallows reading' do
          expect(@join_campus.authorizer).to_not be_readable_by(@participant, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_campus.authorizer).to_not be_updatable_by(@participant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_campus.authorizer).to_not be_deletable_by(@participant, gathering: @gathering)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@participant, gathering: @gathering)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@participant, gathering: @gathering)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@participant, gathering: @gathering)
        end

        it 'disallows deletion' do
          expect(@join_gathering.authorizer).to_not be_deletable_by(@participant, gathering: @gathering)
        end
      end
    end
  end

  context "for the Member" do
      context 'with a Community Membership' do
        it 'allows creation' do
          expect(@join_community.authorizer).to be_creatable_by(@member)
        end
        
        it 'allows reading' do
          expect(@join_community.authorizer).to be_readable_by(@member)
        end

        it 'allows updating' do
          expect(@join_community.authorizer).to be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@join_community.authorizer).to be_deletable_by(@member)
        end
      end

      context 'with a Campus Membership' do
        it 'allows creation' do
          expect(@join_campus.authorizer).to be_creatable_by(@member)
        end
        
        it 'allows reading' do
          expect(@join_campus.authorizer).to be_readable_by(@member)
        end

        it 'allows updating' do
          expect(@join_campus.authorizer).to be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@join_campus.authorizer).to be_deletable_by(@member)
        end
      end

      context 'with a Gathering Membership' do
        it 'disallows creation' do
          expect(@join_gathering.authorizer).to_not be_creatable_by(@member)
        end
        
        it 'allows reading' do
          expect(@join_gathering.authorizer).to be_readable_by(@member)
        end

        it 'disallows updating' do
          expect(@join_gathering.authorizer).to_not be_updatable_by(@member)
        end

        it 'allows deletion' do
          expect(@join_gathering.authorizer).to be_deletable_by(@member)
        end
      end
  end

end
