# == Schema Information
#
# Table name: campuses
#
#  id                 :integer          not null, primary key
#  community_id       :integer          not null
#  name               :string(255)
#  contact_first_name :string(255)
#  contact_last_name  :string(255)
#  email              :string(255)
#  phone              :string(255)
#  street_primary     :string(255)
#  street_secondary   :string(255)
#  city               :string(255)
#  state              :string(255)
#  postal_code        :string(255)
#  time_zone          :string(255)
#  country            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  active_on          :datetime
#  inactive_on        :datetime
#

require 'rails_helper'

describe Campus, type: :model do

  before do
    @campus = build(:campus)
  end

  context 'Name Validation' do
    
    it 'requires a name' do
      @campus.name = nil
      expect(@campus).to be_invalid
      expect(@campus.errors).to have_key(:name)
    end

    it 'rejects short names' do
      @campus.name = "short"
      expect(@campus).to be_invalid
      expect(@campus.errors).to have_key(:name)
    end

    it 'rejects excessively long names' do
      @campus.name = "x" * 256
      expect(@campus).to be_invalid
      expect(@campus.errors).to have_key(:name)
    end
  end

end
