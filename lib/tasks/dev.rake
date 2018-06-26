namespace :dev do

  desc 'Create sample data for local development'
  task prime: ['db:setup'] do
    ensure_development

    require 'factory_bot_rails'
    include FactoryBot::Syntax::Methods

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
      community.add_default_tag_sets!

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
    Request.delete_all
    Membership.delete_all
    Gathering.delete_all
    Campus.delete_all
    Community.delete_all
    Member.delete_all
  end

  def create_leaders(community, campuses, gatherings)
    leader = create(:member, first_name: "A", last_name: "Leader", email: "a.leader@nomail.com")
    assistant = create(:member, first_name: "An", last_name: "Assistant", email: "an.assistant@nomail.com")
    overseer = create(:member, first_name: "An", last_name: "Overseer", email: "an.overseer@nomail.com")
    member = create(:member, first_name: "A", last_name: "Member", email: "a.member@nomail.com")
    visitor = create(:member, first_name: "A", last_name: "Visitor", email: "a.visitor@nomail.com")

    create(:membership, :as_leader, group: community, member: leader)
    create(:membership, :as_assistant, group: community, member: assistant)
    create(:membership, :as_member, group: community, member: member)

    campuses.each_with_index do |campus, i|
      create(:membership, :as_leader, group: campus, member: leader)
      create(:membership, :as_assistant, group: campus, member: assistant)
      create(:membership, :as_member, group: campus, member: member)
      overseer_membership = create(:membership, :as_overseer, group: campus, member: overseer)

      gatherings[i].each do |gathering|
        create(:membership, :as_leader, group: gathering, member: leader)
        create(:membership, :as_assistant, group: gathering, member: assistant)
        create(:assigned_overseer, gathering: gathering, membership: overseer_membership)
      end
    end

    return leader, assistant, overseer, member, visitor
  end

  def create_attached_members(community, campuses, gatherings, blends)
    sizes = [6, 8, 10].cycle

    campuses.each_with_index do |campus, i|
      gatherings[i].each do |gathering|
        create_list(:member, sizes.next).each do |member|
          create(:membership, :as_member, group: community, member: member)
          create(:membership, :as_member, group: campus, member: member)
          create(:membership, :as_member, group: gathering, member: member)
          Preference.for_community(community).for_member(member).take.destroy! rescue nil
          create(:preference, *blends[i], community: community, member: member)
        end
      end
      gatherings[i].each do |gathering|
        gathering.meetings_since(4.months.ago).each do |mt|
          meeting = create(:meeting, gathering: gathering, datetime: mt)
          meeting.ensure_attendees
          meeting.attendance_records.each do |ar|
            next if rand(0..100) > 75
            ar.attend!
          end
        end
      end
    end
  end

  def create_unattached_members(community, blends, seeks)
    traits = [blends.cycle, seeks.cycle].cycle

    75.times do |n|
      member = create(:member)
      create(:preference, *traits.next.next, community: community, member: member)
    end
  end

  def ensure_development
    unless Rails.env.development?
      raise "This task can be used only in the development environment"
    end
  end

end
