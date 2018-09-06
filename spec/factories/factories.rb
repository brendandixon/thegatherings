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

def apply_tags!(o, category, *tags)
  o.add_tags!(category => tags)
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
      after(:create) {|o| apply_tags!(o, :demographics, *%w(twenties thirties)) }
    end

    trait :adults do
      after(:create) {|o| apply_tags!(o, :demographics, *%w(twenties thirties forties)) }
    end

    trait :boomers do
      after(:create) {|o| apply_tags!(o, :demographics, *%w(forties fifties sixties)) }
    end

    trait :seniors do
      after(:create) {|o| apply_tags!(o, :demographics, *%w(sixties plus)) }
    end

    trait :mixed_ages do
      after(:create) {|o| apply_tags!(o, :demographics, *%w(twenties thirties forties fifties sixties plus)) }
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
    trait :any_relationship do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(single young_married early_family established_family empty_nester divorced)) }
    end

    trait :singles do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(single)) }
    end

    trait :young_marrieds do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(young_married)) }
    end

    trait :single_married do
      after(:create) {|o| apply_tags!(o, :relationships, *%w(single young_married)) }
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

    trait :single_life do
      after(:create) {|o| apply_tags!(o, :topics, *%w(singleness bible topical)) }
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

    factory :campus do
      community

      sequence(:name) {|n| "The #{n.ordinalize} Campus" }
      active

      address
      email_address
      phone_number
    end
  
    factory :community do
      sequence(:name) {|n| "The #{n.ordinalize} Church" }
      active
    end

    factory :checkup do
      gathering
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

      occurs { gathering.prior_meeting }
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
      role RoleContext::MEMBER

      RoleContext::ROLES.each do |r|
        trait "as_#{r}".to_sym do
          role r
        end
      end
    end

    factory :preference do
      community
      membership { create(:membership, :as_member, group: community) }
    end

    factory :request do
      campus
      membership { create(:membership, :as_member, group: campus) }

      sent_on 2.weeks.ago
      expires_on 6.weeks.from_now
    end

    factory :request_owner do
      request
      membership { create(:membership, :as_overseer, group: request.campus) }
    end

    factory :role_name do
      community

      role RoleContext::LEADER
      name { I18n.t(role, scope: :roles) }
      group_type Community.to_s
    end

    factory :assigned_overseer do
      gathering
      membership { create(:membership, :as_overseer, group: gathering.campus) }
    end

    factory :category do
      community

      sequence(:name) {|n| "category#{n}"}
    end

    factory :tag do
      category

      sequence(:name) {|n| "#{category}_tag#{n}"}
    end

    factory :tagging do
      association :taggable, factory: :membership
      tag
    end

  end

end
