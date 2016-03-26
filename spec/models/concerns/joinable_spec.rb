require "rails_helper"

describe Joinable, type: :concern do

  before :all do
    @community = create(:community)

    @administrator = create(:member)
    @leader = create(:member)
    @assistant = create(:member)
    @coach = create(:member)
    @member = create(:member)
    @visitor = create(:member)

    @affiliates = [@administrator, @leader, @assistant, @coach, @member]
    @overseers = [@administrator, @leader]
    @assistants = [@assistant]
    @coaches = [@coach]
    @members = [@member]
    @visitors = [@visitor]

    [:administrator, :leader, :assistant, :coach, :member, :visitor].each do |affiliation|
      member = self.instance_variable_get("@#{affiliation}")
      create(:membership, "as_#{affiliation}".to_sym, group: @community, member: member)
    end
  end

  after :all do
    Membership.delete_all
    Community.delete_all
    Member.delete_all
  end

  it 'returns the list of affiliates' do
    expect(@community.affiliates).to match_array(@affiliates)
  end

  it 'returns the list of overseers' do
    expect(@community.overseers).to match_array(@overseers)
  end

  it 'returns the list of assistants' do
    expect(@community.assistants).to match_array(@assistants)
  end

  it 'returns the list of coaches' do
    expect(@community.coaches).to match_array(@coaches)
  end

  it 'returns the list of members' do
    expect(@community.members).to match_array(@members)
  end

  it 'returns the list of visitors' do
    expect(@community.visitors).to match_array(@visitors)
  end

end
