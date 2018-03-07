# == Schema Information
#
# Table name: campuses
#
#  id               :bigint(8)        not null, primary key
#  community_id     :bigint(8)        not null
#  name             :string(255)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  country          :string(255)
#  postal_code      :string(255)
#  email            :string(255)
#  phone            :string(255)
#  primary          :boolean          default(FALSE), not null
#  active_on        :datetime
#  inactive_on      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
