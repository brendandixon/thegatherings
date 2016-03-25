require 'rails_helper'

describe AttendanceRecordAuthorizer, type: :authorizer do

  before :context do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, community: @community, campus: @campus)

    @administrator = create(:member)
    @leader = create(:member)
    @assistant = create(:member)
    @coach = create(:member)
    @member = create(:member)
    @other = create(:member)
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
      create(:membership, :as_member, group: @community, member: @other)
      create(:membership, :as_member, group: @gathering, member: @member)
      @attendance_record = create(:attendance_record, gathering: @gathering, member: @member)
    end

    after :context do
      AttendanceRecord.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@administrator)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@administrator)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@attendance_record.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading' do
        expect(@attendance_record.authorizer).to_not be_readable_by(@assistant)
      end

      it 'disallows updating' do
        expect(@attendance_record.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@attendance_record.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@attendance_record.authorizer).to_not be_creatable_by(@other)
      end

      it 'disallows reading' do
        expect(@attendance_record.authorizer).to_not be_readable_by(@other)
      end

      it 'disallows updating' do
        expect(@attendance_record.authorizer).to_not be_updatable_by(@other)
      end

      it 'disallows deletion' do
        expect(@attendance_record.authorizer).to_not be_deletable_by(@other)
      end
    end
  end

  context "for a Campus" do

    before :context do
      [:administrator, :leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @campus, member: member)
      end
      create(:membership, :as_member, group: @campus, member: @other)
      create(:membership, :as_member, group: @gathering, member: @member)
      @attendance_record = create(:attendance_record, gathering: @gathering, member: @member)
    end

    after :context do
      AttendanceRecord.delete_all
      Membership.delete_all
    end

    context 'Administrator' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@administrator)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@administrator)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@administrator)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@administrator)
      end
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'disallows creation' do
        expect(@attendance_record.authorizer).to_not be_creatable_by(@assistant)
      end

      it 'disallows reading' do
        expect(@attendance_record.authorizer).to_not be_readable_by(@assistant)
      end

      it 'disallows updating' do
        expect(@attendance_record.authorizer).to_not be_updatable_by(@assistant)
      end

      it 'disallows deletion' do
        expect(@attendance_record.authorizer).to_not be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@attendance_record.authorizer).to_not be_creatable_by(@other)
      end

      it 'disallows reading' do
        expect(@attendance_record.authorizer).to_not be_readable_by(@other)
      end

      it 'disallows updating' do
        expect(@attendance_record.authorizer).to_not be_updatable_by(@other)
      end

      it 'disallows deletion' do
        expect(@attendance_record.authorizer).to_not be_deletable_by(@other)
      end
    end
  end

  context "for a Gathering" do

    before :context do
      [:leader, :assistant, :coach, :member].each do |affiliation|
        member = self.instance_variable_get("@#{affiliation}")
        create(:membership, "as_#{affiliation}".to_sym, group: @gathering, member: member)
      end
      create(:membership, :as_member, group: @gathering, member: @other)
      @attendance_record = create(:attendance_record, gathering: @gathering, member: @member)
    end

    after :context do
      AttendanceRecord.delete_all
      Membership.delete_all
    end

    context 'Leader' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@leader)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@leader)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@leader)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@leader)
      end
    end

    context 'Assistant' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@assistant)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@assistant)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@assistant)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@assistant)
      end
    end

    context 'Coach' do
      it 'allows creation' do
        expect(@attendance_record.authorizer).to be_creatable_by(@coach)
      end

      it 'allows reading' do
        expect(@attendance_record.authorizer).to be_readable_by(@coach)
      end

      it 'allows updating' do
        expect(@attendance_record.authorizer).to be_updatable_by(@coach)
      end

      it 'allows deletion' do
        expect(@attendance_record.authorizer).to be_deletable_by(@coach)
      end
    end

    context 'Member' do
      it 'disallows creation' do
        expect(@attendance_record.authorizer).to_not be_creatable_by(@member)
      end

      it 'allows reading their own records' do
        expect(@attendance_record.authorizer).to be_readable_by(@member)
      end

      it 'disallows reading other records' do
        expect(@attendance_record.authorizer).to_not be_readable_by(@other)
      end

      it 'disallows updating' do
        expect(@attendance_record.authorizer).to_not be_updatable_by(@member)
      end

      it 'disallows deletion' do
        expect(@attendance_record.authorizer).to_not be_deletable_by(@member)
      end
    end
  end

  context "for a Member" do

    before :context do
      create(:membership, :as_member, group: @gathering, member: @other)
      create(:membership, :as_member, group: @gathering, member: @member)
      @attendance_record = create(:attendance_record, gathering: @gathering, member: @member)
    end

    after :context do
      AttendanceRecord.delete_all
      Membership.delete_all
    end

    it 'disallows creation' do
      expect(@attendance_record.authorizer).to_not be_creatable_by(@other)
    end

    it 'disallows reading' do
      expect(@attendance_record.authorizer).to_not be_readable_by(@other)
    end

    it 'disallows updating' do
      expect(@attendance_record.authorizer).to_not be_updatable_by(@other)
    end

    it 'disallows deletion' do
      expect(@attendance_record.authorizer).to_not be_deletable_by(@other)
    end
  end

end
