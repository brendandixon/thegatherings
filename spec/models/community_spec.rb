# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Community, type: :model do

  before do
    @community = build(:community)
  end

  context 'Name Validation' do
    it 'requires a name' do
      @community.name = nil
      expect(@community).to be_invalid
      expect(@community.errors).to have_key(:name)
    end

    it 'rejects short names' do
      @community.name = "short"
      expect(@community).to be_invalid
      expect(@community.errors).to have_key(:name)
    end

    it 'rejects excessively long names' do
      @community.name = "x" * 256
      expect(@community).to be_invalid
      expect(@community.errors).to have_key(:name)
    end
  end

  it 'returns itself as its community' do
    expect(@community.community).to eq(@community)
  end

end
