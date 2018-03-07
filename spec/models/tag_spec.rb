# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        unsigned, not null, primary key
#  tag_set_id :bigint(8)        not null
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe TagSet, type: :model do

  before :example do
    @tag = build(:tag)
  end

  it 'validates' do
    expect(@tag).to be_valid
    expect(@tag.errors).to be_empty
  end

  it 'requires a tag set' do
    @tag.tag_set = nil
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:tag_set)
  end

  it 'requires a name' do
    @tag.name = nil
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)

    @tag.name = ''
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)

    @tag.name = '     '
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'rejects short names' do
    @tag.name = 'x'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'rejects long names' do
    @tag.name = 'x' * 500
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'rejects invalid name characters' do
    TestConstants::PUNCUATION_CHARACTERS.each do |ch|
      @tag.name = ch * 10
      expect(@tag).to be_invalid
      expect(@tag.errors).to have_key(:name)
    end
  end

  it 'requires name starts with a word character' do
    @tag.name = ' 20s'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'requires name to end with a word character' do
    @tag.name = '20s '
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'allows name to contain blanks' do
    @tag.name = '20s and 30s'
    expect(@tag).to be_valid
    expect(@tag.errors).to_not have_key(:name)
  end

  it 'disallows duplicate names in a tag set' do
    @tag.save!

    tag = build(:tag, name: @tag.name, tag_set: @tag.tag_set)
    expect(tag).to be_invalid
    expect(tag.errors).to have_key(:name)
  end

  it 'allows duplicate names across tag sets' do
    @tag.save!

    tag = build(:tag, name: @tag.name)
    expect(tag).to be_valid
    expect(tag.errors).to be_empty
  end

end
