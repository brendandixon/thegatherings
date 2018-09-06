namespace :dev do

  class Creator
    @@existing = [
        { category: :young, traits: [:millennials, :mixed_gender, :pcec, :singles, :single_life]},
        { category: :young, traits: [:millennials, :mixed_gender, :pcec, :single_married, :mixed_topics]},
        { category: :young, traits: [:millennials, :mixed_gender, :pcec, :single_married, :mixed_topics]},
        { category: :young, traits: [:millennials, :mixed_gender, :pcec, :single_married, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :mixed, traits: [:boomers, :mixed_gender, :any_relationship, :mixed_topics]},
        { category: :family, traits: [:mixed_ages, :mixed_gender, :established, :families, :family_life]},
        { category: :family, traits: [:mixed_ages, :mixed_gender, :established, :families, :family_life]},
        { category: :women, traits: [:mixed_ages, :women_only, :established, :womens_issues]},
        { category: :women, traits: [:mixed_ages, :women_only, :established, :womens_issues]},
        { category: :men, traits: [:mixed_ages, :men_only, :working, :retired, :singles, :mens_issues]},
        { category: :young, traits: [:mixed_ages, :mixed_gender, :working, :singles, :single_life]},
        { category: :older, traits: [:mixed_ages, :mixed_gender, :established, :family_plus, :mixed_topics]},
        { category: :older, traits: [:mixed_ages, :mixed_gender, :established, :family_plus, :mixed_topics]},
    ]

    @@seeks = [
      [:millennials, :mixed_gender, :pcec, :singles, :single_life],
      [:millennials, :mixed_gender, :pcec, :singles, :single_life],
      [:boomers, :men_only, :established, :mens_issues],
      [:boomers, :women_only, :established, :womens_issues],
      [:boomers, :women_only, :established, :womens_issues],
      [:boomers, :mixed_gender, :any_relationship, :mixed_topics],
      [:mixed_ages, :mixed_gender, :established, :families, :family_life],
      [:mixed_ages, :mixed_gender, :established, :families, :family_life],
      [:mixed_ages, :mixed_gender, :established, :families, :family_life],
      [:mixed_ages, :mixed_gender, :any_relationship, :mixed_topics],
      [:mixed_ages, :mixed_gender, :any_relationship, :mixed_topics],
      [:mixed_ages, :mixed_gender, :established, :family_plus, :mixed_topics],
    ]

    @@names = {
      young: [
        'Rooted',
        'Awakened',
        'reKindled',
        'Connected',
        'Encounter',
        'Witnesses',
        'Thriving',
      ],
      family: [
        'All in the Family',
        'Reproduced',
        'New Seedlings',
        'Sleepless Saints',
        'Raising & Praying',
        'Proud Parents',
      ],
      mixed: [
        'Redeemed',
        'Friends & Family',
        'Saved & Seeking',
        'Fruit Factories',
        'Learning to Love',
        'Stewards',
        'New Family',
        'Step by Step',
        'Poems in Action',
        'Dinner & The Bible',
        'Faith & Grace',
        'Chosen Ones',
        'Reflections',
        'Angled Mirrors',
        'Rescued Servants',
        'Freed',
        'Table & Topics',
      ],
      older: [
        'Autumn Leaves',
        'Happy Timers',
        'Prime Timers',
        'Young at Heart',
        'Finally Mature',
        'All Grown Up',
        'Been There, Done That',
        'Leisure Timers',
        'Best Years',
        'Ageless Wonders',
        'Morning Risers',
      ],
      men: [
        'Rough & Tumble',
        'Pillars',
        'Standing Strong',
        'On Our Knees',
        'Going the Distance',
      ],
      women: [
        'Flourishing Faithful',
        'Real Beauties',
        'Friends in Formation',
        'Bible with Brunch',
      ]
    }

    # Use a fixed seed to create stable data
    SEED = 127205307310996961695067664992737497078
    @@generator = Random.new(SEED)

    class<<self
      def purge_all
        AssignedOverseer.delete_all
        AttendanceRecord.delete_all
        Campus.delete_all
        Category.delete_all
        Community.delete_all
        Gathering.delete_all
        Meeting.delete_all
        Member.delete_all
        Membership.delete_all
        Preference.delete_all
        Request.delete_all
        RoleName.delete_all
        Tag.delete_all
        Tagging.delete_all
      end

      def create_community
        community = create(:community, name: 'Bethany Community Church')
        community.add_default_categories!

        campuses = [
          { name: 'Ballard', gatherings: 5 },
          { name: 'Eastside', gatherings: 3 },
          { name: 'Green Lake', gatherings: 14 },
          { name: 'North', gatherings: 5 },
          { name: 'Northeast', gatherings: 3 },
          { name: 'West Seattle', gatherings: 3 }
        ].map do |c|
          puts "...Creating Campus #{c[:name]}"
          campus = create(:campus, community: community, name: c[:name])
          
          puts "...Creating #{c[:gatherings]} Gatherings for Campus #{c[:name]}"
          (0..c[:gatherings]).each do
            g = one_of(*@@existing)
            create(:gathering, *g[:traits], name: name_for(g[:category]), campus: campus, community: community)
          end
        end
      end

      def create_leaders
        puts "...Creating Leaders"
        community = Community.first

        leader = create(:member, first_name: "A", last_name: "Leader", email: "a.leader@nomail.com")
        assistant = create(:member, first_name: "An", last_name: "Assistant", email: "an.assistant@nomail.com")

        create(:membership, :as_leader, group: community, member: leader)
        create(:membership, :as_assistant, group: community, member: assistant)

        Campus.all.each do |campus|
          cn = campus.name.remove(' ')

          leader = create(:member, first_name: cn, last_name: "Leader", email: "#{cn.underscore}.leader@nomail.com")
          assistant = create(:member, first_name: cn, last_name: "Assistant", email: "#{cn.underscore}.assistant@nomail.com")
          overseer = create(:member, first_name: cn, last_name: "Overseer", email: "#{cn.underscore}.overseer@nomail.com")

          create(:membership, :as_member, group: community, member: leader)
          create(:membership, :as_member, group: community, member: assistant)
          create(:membership, :as_member, group: community, member: overseer)

          create(:membership, :as_leader, group: campus, member: leader)
          create(:membership, :as_assistant, group: campus, member: assistant)

          overseer_membership = create(:membership, :as_overseer, group: campus, member: overseer)
          campus.gatherings.each{|gathering| create(:assigned_overseer, gathering: gathering, membership: overseer_membership)}
        end
      end

      def create_members
        puts "...Creating Members"
        community = Community.first

        Campus.all.each do |campus|
          campus.gatherings.each do |gathering|
            n = one_of(*(4..12))
            puts "...Creating #{n} Members for Gathering #{gathering} at #{campus} "
            create_list(:member, n).each_with_index do |member, i|
              community_membership = create(:membership, :as_member, group: community, member: member)
              create(:membership, :as_member, group: campus, member: member)

              role =  case i
                        when 0 then :as_leader
                        when 1 then :as_assistant
                        else :as_member
                      end
              create(:membership, role, group: gathering, member: member)

              p = create(:preference, campus: campus, community: community, membership: community_membership)
              p.add_tags!(gathering.tags)
            end
          end
        end
      end

      def create_meetings
        Campus.all.each do |campus|
          campus.gatherings.each do |gathering|
            puts "...Adding meetings to Gathering #{gathering} at #{campus}"
            gathering.meetings_since(3.months.ago.beginning_of_month).each do |mt|
              meeting = create(:meeting, gathering: gathering, occurs: mt)
              meeting.ensure_attendees
              meeting.attendance_records.each do |ar|
                next if @@generator.rand(0..100) > 65
                ar.attend!
              end
              meeting.settle_attendance!

              gs = (meeting.attendance.first.to_f / meeting.attendance.last.to_f) * 100.0
              as = @@generator.rand(30...100)
              ss = @@generator.rand(45...100)
              rs = @@generator.rand(0...100)
              create(:checkup, gathering: gathering, week_of: mt, gather_score: gs, adopt_score: as, shape_score: ss, reflect_score: rs)
            end
          end
        end
      end

      def create_requests
        puts "...Creating Requests"
        community = Community.first

        community.campuses.each do |campus|
          one_of(*(2..10)).times do |n|
            member = create(:member)
            community_membership = create(:membership, :as_member, group: community, member: member)
            campus_membership = create(:membership, :as_member, group: campus, member: member)
            create(:preference, *one_of(*@@seeks), community: community, campus: campus, membership: community_membership)
            gathering = @@generator.rand(0..100) > 66 ? one_of(*campus.gatherings) : nil
            r = create(:request, campus: campus, gathering: gathering, membership: campus_membership)
            create(:request_owner, membership: one_of(*campus.all_leaders), request: r) if @@generator.rand(0..100) > 33
            r.respond!(one_of(*Request::STATUSES))
          end
        end
      end

      def name_for(category)
        one_of(*@@names[category])
      end

      def one_of(*options)
        options[@@generator.rand(0...options.length)]
      end
    end
  end

  desc 'Create sample data for local development'
  task prime: ['db:setup'] do
    raise "This task can be used only in the development environment" unless Rails.env.development?

    require 'factory_bot_rails'
    include FactoryBot::Syntax::Methods

    Time.use_zone TheGatherings::Application.default_time_zone do
      st = Time.now

      Creator.purge_all
      Creator.create_community
      Creator.create_leaders
      Creator.create_members
      Creator.create_meetings
      Creator.create_requests

      et = ActiveSupport::Duration.build(Time.now - st).parts
      puts "Creation completed in #{et[:minutes]} minutes and #{et[:seconds]} seconds"
    end

  end

end
