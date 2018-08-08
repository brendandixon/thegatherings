# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        unsigned, not null, primary key
#  category_id :bigint(8)        not null
#  name       :string(255)
#  prompt     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Category, type: :model do

  before :example do
    @tag = build(:tag)
  end

  it 'validates' do
    expect(@tag).to be_valid
    expect(@tag.errors).to be_empty
  end

  it 'requires a tag set' do
    @tag.category = nil
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:category)
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

  it 'rejects names with puncutation characters' do
    TestConstants::PUNCUATION_CHARACTERS.each do |ch|
      @tag.name = ch * 10
      expect(@tag).to be_invalid
      expect(@tag.errors).to have_key(:name)
    end
  end

  it 'requires name starts with a word character' do
    @tag.name = ' twenties'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'requires name to end with a word character' do
    @tag.name = 'twenties '
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'rejects names containing non-word characters' do
    @tag.name = 'twenties and thirties'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'disallows duplicate names in a tag set' do
    @tag.save!

    tag = build(:tag, name: @tag.name, category: @tag.category)
    expect(tag).to be_invalid
    expect(tag.errors).to have_key(:name)
  end

  it 'allows duplicate names across tag sets' do
    @tag.save!

    tag = build(:tag, name: @tag.name)
    expect(tag).to be_valid
    expect(tag.errors).to be_empty
  end

  it 'rejects short names' do
    @tag.name = 'xx'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'rejects long names' do
    @tag.name = 'x' * 500
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:name)
  end

  it 'allows puncuation prompt characters' do
    (TestConstants::PUNCUATION_CHARACTERS + %w(' -)).each do |ch|
      @tag.prompt = 'x' + ch * 10
      expect(@tag).to be_valid
      expect(@tag.errors).to_not have_key(:prompt)
    end
  end

  it 'requires prompt starts with a word character' do
    @tag.prompt = ' 20s'
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:prompt)
  end

  it 'requires prompt to end with a word character' do
    @tag.prompt = '20s '
    expect(@tag).to be_invalid
    expect(@tag.errors).to have_key(:prompt)
  end

  it 'allows prompt to contain blanks' do
    @tag.prompt = '20s and 30s'
    expect(@tag).to be_valid
    expect(@tag.errors).to_not have_key(:prompt)
  end

end
