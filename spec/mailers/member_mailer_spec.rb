require "rails_helper"

describe MemberMailer, type: :mailer do

  before :all do
    @community = create(:community)
    @campus = create(:campus, community: @community)
    @gathering = create(:gathering, campus: @campus)
    @leader = create(:member)
    @member = create(:member)
    
    create(:membership, :as_member, group: @campus, member: @leader)
    @membership = create(:membership, :as_member, group: @campus, member: @member)
    create(:membership, :as_leader, group: @gathering, member: @leader)
  end

  after :all do
    Membership.delete_all
    Gathering.delete_all
    Community.delete_all
    Member.delete_all
  end

  describe "answer_request" do

    before :each do
      @request = create(:request, campus: @campus, membership: @membership, gathering: @gathering)
      @request.accepted!
      @mail = MemberMailer.answer_request(@leader, @request, "You may join")
    end

    after :each do
      Request.delete_all
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
