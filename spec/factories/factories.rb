# To use FactoryBot within in the console:
#     rails console -e test --sandbox
#     require "factory_bot"
#     require "./factories"
#     include FactoryBot::Syntax::Methods
# See https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md
#

def add_factories
  include FactoryBot::Syntax::Methods
end

def apply_tags!(o, tag_set, *tags)
  o.add_tags!(o.community.tag_sets.with_name(tag_set).take.tags.with_name(tn(tag_set, *tags)).all)
end

def ts(ts)
  I18n.t('title', scope: [:tags, ts])
end

def tn(ts, *tags)
  tags.map{|t| I18n.t(t, scope: [:tags, ts])}
end

Time.use_zone TheGatherings::Application.default_time_zone do

  genders = Member::GENDERS.cycle
  postal_codes = %w(98103 98105 98107 98112 98115 98117 98119 98199).cycle
  sentence = "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "

  FactoryBot.define do

    sequence :gender, genders

    trait :address do
      sequence(:street_primary, 1000) {|n| "#{n} 56th Avenue" }
      city "Seattle"
      state "WA"
      sequence :postal_code, postal_codes
      country "US"
    end

    trait :email_address do
      sequence(:email) {|n| "member#{n}@nomail.com" }
    end

    trait :phone_number do
      sequence(:phone, 1000) {|n| "123.555.#{n}" }
    end

    trait :active do
      active_on 1.year.ago
    end

    trait :inactive do
      active_on 5.years.ago
      inactive_on DateTime.yesterday
    end

    %w(monday tuesday wednesday thursday friday saturday sunday).each_with_index do |day, i|
      trait "meets_#{day}".to_sym do
        meeting_day i
      end
    end

    # Age Mix
    trait :millennials do
      after(:create) {|o| apply_tags!(o, :age_groups, *%w(twenties thirties)) }
    end

    trait :boomers do
      after(:create) {|o| apply_tags!(o, :age_groups, *%w(forties fifties sixties)) }
    end

    trait :mixed_ages do
      after(:create) {|o| apply_tags!(o, :age_groups, *%w(twenties thirties forties fifties sixties)) }
    end

    # Gender Mix
    trait :men_only do
      after(:create) {|o| apply_tags!(o, :genders, *%w(men)) }
    end

    trait :women_only do
      after(:create) {|o| apply_tags!(o, :genders, *%w(women)) }
    end

    trait :mixed_gender do
      after(:create) {|o| apply_tags!(o, :genders, *%w(mixed)) }
    end

    # Life Stage Mix
    trait :pcec do
      after(:create) {|o| apply_tags!(o, :life_stages, *%w(post_college early_career)) }
    end

    trait :working do
      after(:create) {|o| apply_tags!(o, :life_stages, *%w(early_career established_career)) }
    end

    trait :established do
      after(:create) {|o| apply_tags!(o, :life_stages, *%w(established_career post_career)) }
    end

    trait :retired do
      after(:create) {|o| apply_tags!(o, :life_stages, *%w(post_career)) }
    end

    # Relational Status Mix
    trait :singles do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(single)) }
    end

    trait :young_marrieds do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(young_married)) }
    end

    trait :families do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(early_family established_family)) }
    end

    trait :family_plus do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(established_family empty_nester divorced)) }
    end

    trait :post_family do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(empty_nester divorced)) }
    end

    # Topic Mix
    trait :family_life do
      after(:create) {|o| apply_tags!(o, :topics, *%w(family marriage)) }
    end

    trait :mens_issues do
      after(:create) {|o| apply_tags!(o, :topics, *%w(men)) }
    end

    trait :womens_issues do
      after(:create) {|o| apply_tags!(o, :topics, *%w(women)) }
    end

    trait :mixed_topics do
      after(:create) {|o| apply_tags!(o, :topics, *%w(bible devotional topical)) }
    end

    factory :member do
      gender
      sequence(:first_name) {|n| gender == "male" ? "Mike#{n}" : "Mary#{n}"}
      last_name "Member"
      time_zone Time.zone.name

      address
      email_address
      phone_number
    end
  
    factory :community do
      sequence(:name) {|n| "The #{n.ordinalize} Church" }
      active
    end

    factory :campus do
      community

      sequence(:name) {|n| "The #{n.ordinalize} Campus" }
      active

      address
      email_address
      phone_number
    end

    factory :gathering do
      campus

      sequence(:name) {|n| "#{n.ordinalize} Gathering" }
      description { (sentence * 2).strip! }
      time_zone Time.zone.name
      meeting_starts 1.year.ago.beginning_of_week
      meeting_ends 1.year.from_now
      meeting_time 19.hours
      meets_tuesday
      meeting_duration 90.minutes

      address
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
      association :group, factory: :campus
      member

      active_on 6.months.ago
      role ApplicationAuthorizer::MEMBER

      ApplicationAuthorizer::ROLES.each do |r|
        trait "as_#{r}".to_sym do
          role r
        end
      end
    end

    factory :membership_request do
      gathering
      member

      sent_on 2.weeks.ago
      expires_on 1.week.from_now
    end

    factory :preference do
      community
      member
    end

    factory :role_name do
      community

      role ApplicationAuthorizer::LEADER
      name { I18n.t(role, scope: :roles) }
      group_type Community.to_s
    end

    factory :assigned_overseer do
      gathering
      membership { create(:membership, :as_overseer, group: gathering.campus) }
    end

    factory :tag_set do
      community

      sequence(:name) {|n| "TagSet#{n}"}
    end

    factory :tag do
      tag_set

      sequence(:name) {|n| "#{tag_set}-Tag#{n}"}
    end

    factory :tagging do
      association :taggable, factory: :membership
      tag
    end

  end

end
