namespace :dev do

  desc 'Create sample data for local development'
  task prime: ['db:setup'] do
    ensure_development

    require 'factory_girl_rails'
    include FactoryGirl::Syntax::Methods

    purge_all

    blends = [
      [:millennials, :women_only, :pcec, :singles, :mixed_topics],
      [:mixed_ages, :men_only, :working, :singles, :mixed_topics],
      [:mixed_ages, :mixed_gender, :established, :family_plus, :mixed_topics],
    ]

    seeks = [
      [:millennials, :mixed_gender, :pcec, :singles, :mixed_topics],
      [:millennials, :mixed_gender, :pcec, :singles, :mixed_topics],
      [:boomers, :men_only, :established, :mens_issues],
      [:boomers, :women_only, :established, :womens_issues],
      [:boomers, :women_only, :established, :womens_issues],
      [:boomers, :women_only, :established, :womens_issues],
      [:mixed_ages, :mixed_gender, :established, :families, :family_life],
      [:mixed_ages, :mixed_gender, :established, :families, :family_life]
    ]

    Time.use_zone TheGatherings::Application.default_time_zone do
      community = create(:community)
      campuses = create_list(:campus, 3, community: community)

      gatherings = []
      campuses.each do |campus|
        gatherings << blends.map{|blend| create(:gathering, *blend, campus: campus, community: community)}
      end

      create_leaders(community, campuses, gatherings)
      create_attached_members(community, campuses, gatherings, blends)
      create_unattached_members(community, blends, seeks)
    end
  end

  def purge_all
    AttendanceRecord.delete_all
    MembershipRequest.delete_all
    Membership.delete_all
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  def create_leaders(community, campuses, gatherings)
    administrator = create(:member, first_name: "A", last_name: "Admin")
    leader = create(:member, first_name: "A", last_name: "Leader")
    assistant = create(:member, first_name: "An", last_name: "Assistant")
    coach = create(:member, first_name: "A", last_name: "Coach")

    create(:membership, :as_administrator, group: community, member: administrator)
    create(:membership, :as_leader, group: community, member: leader)
    create(:membership, :as_assistant, group: community, member: assistant)
    create(:membership, :as_coach, group: community, member: coach)

    campuses.each_with_index do |campus, i|
      create(:membership, :as_administrator, group: campus, member: administrator)
      create(:membership, :as_leader, group: campus, member: leader)
      create(:membership, :as_assistant, group: campus, member: assistant)
      create(:membership, :as_coach, group: campus, member: coach)

      gatherings[i].each do |gathering|
        create(:membership, :as_leader, group: gathering, member: leader)
        create(:membership, :as_assistant, group: gathering, member: assistant)
        create(:membership, :as_coach, group: gathering, member: coach)
      end
    end

    return administrator, leader, assistant, coach
  end

  def create_attached_members(community, campuses, gatherings, blends)
    sizes = [6, 8, 10].cycle

    campuses.each_with_index do |campus, i|
      gatherings[i].each do |gathering|
        create_list(:member, sizes.next).each do |member|
          create(:membership, :as_member, *blends[i], group: community, member: member)
          create(:membership, :as_member, group: campus, member: member)
          create(:membership, :as_member, group: gathering, member: member)
          gathering.prior_meetings(DateTime.now, 10).each do |mt|
            next if rand(0..100) > 75
            create(:attendance_record, gathering: gathering, member: member, datetime: mt)
          end
        end
      end
    end
  end

  def create_unattached_members(community, blends, seeks)
    traits = [blends.cycle, seeks.cycle].cycle

    50.times do |n|
      member = create(:member)
      create(:membership, :as_member, *traits.next.next, group: community, member: member)
    end
  end

  def ensure_development
    unless Rails.env.development?
      raise "This task can be used only in the development environment"
    end
  end

end
