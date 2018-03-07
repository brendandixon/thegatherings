# == Schema Information
#
# Table name: tag_sets
#
#  id           :bigint(8)        unsigned, not null, primary key
#  community_id :bigint(8)
#  name         :string(255)
#  single       :string(255)
#  plural       :string(255)
#  prompt       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

describe TagSet, type: :model do

  before :example do
    @ts = build(:tag_set)
    @tags = %w(aa bb cc dd ee ff gg)
  end

  it 'validates' do
    expect(@ts).to be_valid
    expect(@ts.errors).to be_empty
  end

  it 'requires a community' do
    @ts.community = nil
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:community)
  end

  it 'requires a name' do
    @ts.name = nil
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:name)
  end

  it 'rejects short names' do
    @ts.name = 'xx'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:name)
  end

  it 'rejects long names' do
    @ts.name = 'x' * 500
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:name)
  end

  it 'rejects invalid name characters' do
    TestConstants::PUNCUATION_CHARACTERS.each do |ch|
      @ts.name = ch * 10
      expect(@ts).to be_invalid
      expect(@ts.errors).to have_key(:name)
    end
  end

  it 'rejects blank names' do
    @ts.name = '     '
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:name)

    @ts.name = '  x  '
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:name)
  end

  it 'disallows duplicate names by community' do
    @ts.save!

    ts = build(:tag_set, name: @ts.name, community: @ts.community)
    expect(ts).to be_invalid
    expect(ts.errors).to have_key(:name)
  end

  it 'allows duplicate names across communities' do
    @ts.save!

    ts = build(:tag_set)
    expect(@ts.community).to_not be(ts.community)
    expect(ts).to be_valid
    expect(ts.errors).to be_empty
  end

  it 'ensures a single value' do
    @ts.name = "age_groups"
    @ts.single = nil
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:single)

    @ts.single = '     '
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:single)
  end

  it 'rejects short single values' do
    @ts.single = 'x'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:single)
  end

  it 'rejects long single values' do
    @ts.single = 'x' * 500
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:single)
  end

  it 'rejects invalid single characters' do
    TestConstants::PUNCUATION_CHARACTERS.each do |ch|
      @ts.single = ch * 10
      expect(@ts).to be_invalid
      expect(@ts.errors).to have_key(:single)
    end
  end

  it 'requires single starts with a word character' do
    @ts.single = ' Age Group'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:single)
  end

  it 'requires single to end with a word character' do
    @ts.single = 'Age Group '
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:single)
  end

  it 'allows single to contain blanks' do
    @ts.single = 'Age Group'
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:single)
  end

  it 'ensures a plural value' do
    @ts.single = 'Age Group'
    @ts.plural = nil
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:plural)

    @ts.plural = '     '
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:plural)
  end

  it 'rejects short plural values' do
    @ts.plural = 'x'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:plural)
  end

  it 'rejects long plural values' do
    @ts.plural = 'x' * 500
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:plural)
  end

  it 'rejects invalid plural characters' do
    TestConstants::PUNCUATION_CHARACTERS.each do |ch|
      @ts.plural = ch * 10
      expect(@ts).to be_invalid
      expect(@ts.errors).to have_key(:plural)
    end
  end

  it 'requires plural starts with a word character' do
    @ts.plural = ' Age Groups'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:plural)
  end

  it 'requires plural to end with a word character' do
    @ts.plural = 'Age Groups '
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:plural)
  end

  it 'allows plural to contain blanks' do
    @ts.plural = 'Age Groups'
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:plural)
  end

  it 'ensures a prompt value' do
    @ts.plural = 'Age Groups'
    @ts.prompt = nil
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:prompt)

    @ts.prompt = '     '
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:prompt)
  end

  it 'rejects short prompt values' do
    @ts.prompt = 'xx'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:prompt)
  end

  it 'rejects long prompt values' do
    @ts.prompt = 'x' * 500
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:prompt)
  end

  it 'allows puncuation prompt characters' do
    (TestConstants::PUNCUATION_CHARACTERS + %w(' -)).each do |ch|
      @ts.prompt = 'x' + ch * 10
      expect(@ts).to be_valid
      expect(@ts.errors).to_not have_key(:prompt)
    end
  end

  it 'requires prompt starts with a word character' do
    @ts.prompt = ' Preferred Age Groups?'
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:prompt)
  end

  it 'requires prompt to end with a word character' do
    @ts.prompt = 'Preferred Age Groups? '
    expect(@ts).to be_invalid
    expect(@ts.errors).to have_key(:prompt)
  end

  it 'allows prompt to contain blanks' do
    @ts.prompt = 'Preferred Age Groups?'
    expect(@ts).to be_valid
    expect(@ts.errors).to_not have_key(:prompt)
  end

  it 'adds tags to a new tag set' do
    expect(@ts).to be_new_record

    @ts.add_tags!(@tags)
    expect(@ts.tags.length).to eq(@tags.length)
    expect(@ts.tags.map{|t| t.name}.sort).to eq(@tags)
  end

  it 'adds tags to an existing tag set' do
    @ts.save!

    @ts.add_tags!(@tags)
    expect(@ts.tags.length).to eq(@tags.length)
    expect(@ts.tags.map{|t| t.name}.sort).to eq(@tags)
  end

  it 'removes tags from the set' do
    @ts.save!
    @ts.add_tags!(@tags)

    @ts.remove_tags!(@tags.first, @tags.last)
    tags = @tags[1..-2]
    expect(@ts.tags.length).to eq(tags.length)
    expect(@ts.tags.map{|t| t.name}.sort).to eq(tags)
  end

end
