require "rails_helper"

describe MemberMailer, type: :mailer do

  before :all do
    @community = create(:community)
    @gathering = create(:gathering, community: @community)
    @leader = create(:leader)
    @member = create(:member)
    
    create(:community_membership, group: @community, member: @leader)
    create(:community_membership, group: @community, member: @member)
    create(:gathering_membership, group: @gathering, member: @leader, role: 'leader')
  end

  after :all do
    Membership.delete_all
    Gathering.delete_all
    Community.delete_all
    Member.delete_all
  end

  describe "answer_membership_request" do

    before :each do
      @membership_request = create(:membership_request, member: @member, gathering: @gathering)
      @membership_request.answer!
      @mail = MemberMailer.answer_membership_request(@leader, @membership_request, "You may join")
    end

    after :each do
      MembershipRequest.delete_all
    end

    it "renders the headers" do
      expect(@mail.subject).to include(@gathering.name)
      expect(@mail.to).to eq([@member.email])
      expect(@mail.from).to eq([@leader.email])
    end

    it "renders the body" do
      body = @mail.body.encoded
      expect(body).to_not be_empty
      expect(body).to include(@member.first_name)
      expect(body).to include(@leader.full_name)
      expect(body).to include(@gathering.name)
    end

  end

end
