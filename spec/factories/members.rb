# == Schema Information
#
# Table name: members
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  gender                 :string(25)       default(""), not null
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)
#  postal_code            :string(25)
#  country                :string(2)
#  time_zone              :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#

FactoryGirl.define do
  factory :admin, class: 'Member' do
    first_name "Adam"
    last_name "Administrator"
    gender "male"
    email "adam.administrator@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :leader, class: 'Member' do
    first_name "Lenora"
    last_name "Leader"
    gender "female"
    email "lenora.leader@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :coach, class: 'Member' do
    first_name "Calvin"
    last_name "coach"
    gender "male"
    email "calvin.coach@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :assistant, class: 'Member' do
    first_name "Andrea"
    last_name "Assistant"
    gender "female"
    email "andrea.assistant@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :participant, class: 'Member' do
    first_name "Peter"
    last_name "Participant"
    gender "male"
    email "peter.participant@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :member, class: 'Member' do
    first_name "Mary"
    last_name "Member"
    gender "female"
    email "mary.member@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end

  factory :visitor, class: 'Member' do
    first_name "Vicki"
    last_name "Visitor"
    gender "female"
    email "vicki.visitor@nomail.com"
    phone "123.555.1212"
    postal_code "12345"
  end
end
