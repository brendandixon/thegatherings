# == Schema Information
#
# Table name: members
#
#  id                     :bigint(8)        not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  gender                 :string(25)       default(""), not null
#  street_primary         :string(255)
#  street_secondary       :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  postal_code            :string(255)
#  email                  :string(255)
#  phone                  :string(255)
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
#  provider               :string(255)
#  uid                    :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

describe Member, type: :model do

  before do
    @member = build(:member)
  end

  # Note: Testing ActiveSupport::TimeZone conversion here since ActiveModel does not yet support type casts
  it 'converts TimeZone to its name' do
    @member.time_zone = ActiveSupport::TimeZone.all.first
    expect(@member.read_attribute(:time_zone)).to be_a(String)
  end

  context 'Name Validation' do
    it 'requires a first name' do
      @member.first_name = nil
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:first_name)
    end

    it 'rejects short names' do
      @member.first_name = ""
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:first_name)
    end

    it 'rejects excessively long names' do
      @member.first_name = "x" * 256
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:first_name)
    end

    it 'requires a last name' do
      @member.last_name = nil
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:last_name)
    end

    it 'rejects short names' do
      @member.last_name = ""
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:last_name)
    end

    it 'rejects excessively long names' do
      @member.last_name = "x" * 256
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:last_name)
    end
  end

  context 'Name Helpers' do
    it 'returns an abbreviated name' do
      expect(@member.abbreviated_name).to eq("#{@member.first_name} #{@member.last_name.first}.")
    end

    it 'returns a full name' do
      expect(@member.full_name).to eq("#{@member.first_name} #{@member.last_name}")
    end

    it 'ensures first names are capitalized' do
      @member.first_name = "foo"
      expect(@member.first_name).to eq("Foo")
    end

    it 'ensures last names are capitalized' do
      @member.last_name = "foo"
      expect(@member.last_name).to eq("Foo")
    end
  end

  context 'Gender Validation' do
    it 'requires a gender' do
      @member.gender = nil
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:gender)
    end

    it 'accepts female as a gender' do
      @member.gender = :female
      expect(@member).to be_valid
      expect(@member.errors).to_not have_key(:gender)
    end

    it 'accepts male as a gender' do
      @member.gender = :male
      expect(@member).to be_valid
      expect(@member.errors).to_not have_key(:gender)
    end

    it 'rejects any other value for gender' do
      @member.gender = 'not a gender'
      expect(@member).to be_invalid
      expect(@member.errors).to have_key(:gender)
    end

  end

  context 'Membership Helpers' do
    
    before :all do
      @community = create(:community)
      @campus = create(:campus, community: @community)
      @gathering = create(:gathering, campus: @campus)
    end

    before :each do
      @member = create(:member)
    end

    it 'identifies assistants' do
      expect(@member).to_not be_assistant_for(@gathering)

      create(:membership, :as_assistant, group: @gathering, member: @member)
      expect(@member).to be_assistant_for(@gathering)
    end

    it 'identifies leaders' do
      expect(@member).to_not be_leader_of(@gathering)

      create(:membership, :as_leader, group: @gathering, member: @member)
      expect(@member).to be_leader_of(@gathering)
    end

    it 'identifies members' do
      expect(@member).to_not be_member_of(@gathering)

      create(:membership, :as_member, group: @gathering, member: @member)
      expect(@member).to be_member_of(@gathering)
    end

    it 'identifies participants' do
      expect(@member).to_not be_participant_in(@gathering)

      create(:membership, :as_member, group: @gathering, member: @member)
      expect(@member).to be_participant_in(@gathering)
    end

    it 'identifies visitors' do
      expect(@member).to_not be_visitor_to(@gathering)

      create(:membership, :as_visitor, group: @gathering, member: @member)
      expect(@member).to be_visitor_to(@gathering)
    end

  end

end
