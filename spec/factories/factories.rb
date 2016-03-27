# To use FactoryGirl within in the console:
#     require "factory_girl"
#     require "./factories"
#     include FactoryGirl::Syntax::Methods

Time.use_zone TheGatherings::Application.default_time_zone do

  genders = Member::GENDERS.cycle
  postal_codes = %w(98103 98105 98107 98112 98115 98117 98119 98199).cycle
  sentence = "A very long, rambling sentence saying nothing, meaning nothing, but is here nonetheless. "

  FactoryGirl.define do

    trait :active do
      active_on 1.year.ago
    end

    trait :inactive do
      active_on 5.years.ago
      inactive_on DateTime.yesterday
    end

    trait :address do
      sequence(:street_primary, 1000) {|n| "#{n} 56th Avenue" }
      city "Seattle"
      state "WA"
      postal_code
      country "US"
      time_zone Time.zone.name
    end

    %w(monday tuesday wednesday thursday friday saturday sunday).each_with_index do |day, i|
      trait "meets_#{day}".to_sym do
        meeting_day i
      end
    end

    # Age Mix
    trait :millennials do
      after(:build) {|o| o.age_group_list = %w(twenties thirties) }
    end

    trait :boomers do
      after(:build) {|o| o.age_group_list = %w(forties fifties sixties) }
    end

    trait :mixed_ages do
      after(:build) {|o| o.age_group_list = %w(twenties thirties forties fifties sixties) }
    end

    # Gender Mix
    trait :men_only do
      after(:build) {|o| o.gender_list = %w(men) }
    end

    trait :women_only do
      after(:build) {|o| o.gender_list = %w(women) }
    end

    trait :mixed_gender do
      after(:build) {|o| o.gender_list = %w(mixed) }
    end

    # Life Stage Mix
    trait :pcec do
      after(:build) {|o| o.life_stage_list = %w(post_college early_career) }
    end

    trait :working do
      after(:build) {|o| o.life_stage_list = %w(early_career established_career) }
    end

    trait :established do
      after(:build) {|o| o.life_stage_list = %w(established_career post_career) }
    end

    trait :retired do
      after(:build) {|o| o.life_stage_list = %w(post_career) }
    end

    # Relational Status Mix
    trait :singles do
      after(:build) {|o| o.relationship_list = %w(single) }
    end

    trait :young_marrieds do
      after(:build) {|o| o.relationship_list = %w(young_married) }
    end

    trait :families do
      after(:build) {|o| o.relationship_list = %w(early_family established_family) }
    end

    trait :family_plus do
      after(:build) {|o| o.relationship_list = %w(established_family empty_nester divorced) }
    end

    trait :post_family do
      after(:build) {|o| o.relationship_list = %w(empty_nester divorced) }
    end

    # Topic Mix
    trait :family_life do
      after(:build) {|o| o.topic_list = %w(family marriage) }
    end

    trait :mens_issues do
      after(:build) {|o| o.topic_list = %w(men) }
    end

    trait :womens_issues do
      after(:build) {|o| o.topic_list = %w(women) }
    end

    trait :mixed_topics do
      after(:build) {|o| o.topic_list = %w(bible devotional topical) }
    end

    sequence :gender, genders

    sequence :phone, 1000 do |n|
      "123.555.#{n}"
    end

    sequence :postal_code, postal_codes

    factory :member do
      gender
      sequence(:first_name) {|n| gender == "male" ? "Mike#{n}" : "Mary#{n}"}
      last_name "Member"
      email { "#{first_name}.#{last_name}@nomail.com".downcase }
      phone
      postal_code
    end
  
    factory :community do
      sequence(:name) {|n| "The #{n.ordinalize} Reformed Charismatic Methodist Baptist Church" }
      active
    end

    factory :campus do
      community

      sequence(:name) {|n| "The #{n.ordinalize} Campus" }
      phone
      sequence(:email) {|n| "campus#{n}@nomail.com"}
      address
      active
    end

    factory :gathering do
      community
      campus

      sequence(:name) {|n| "#{n.ordinalize} Gathering of Orthodox Baptists" }
      description { (sentence * 7).strip! }
      address
      meeting_starts 1.year.ago.beginning_of_week
      meeting_ends 1.year.from_now
      meeting_time 19.hours
      meets_tuesday
      meeting_duration 90.minutes
    end

    factory :meeting do
      gathering

      datetime { gathering.prior_meeting }
    end

    factory :attendance_record do
      meeting
      membership

      attended true
    end
    
    factory :membership do
      association :group, factory: :community
      member

      active_on 6.months.ago

      ApplicationAuthorizer::ROLES.each do |r|
        trait "as_#{r}".to_sym do
          role r
        end
      end

      ApplicationAuthorizer::PARTICIPANTS.each do |p|
        trait "as_#{p}".to_sym do
          participant p
        end
      end
    end

    factory :membership_request do
      gathering
      member

      sent_on 2.weeks.ago
      expires_on 1.week.from_now
    end

  end

end
