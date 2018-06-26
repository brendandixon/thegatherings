require "rails_helper"

describe Taggable, type: :concern do

  before :all do
    @c = create(:community)
    @ca = create(:campus, community: @c)

    @ts1 = @c.tag_sets.create!(name: "tagset1")
    @ts2 = @c.tag_sets.create!(name: "tagset2")

    @tags1 = (0..2).map{|n| @ts1.tags.create!(name: "#{@ts1.name}_tag#{n}")}
    @tags2 = (0..2).map{|n| @ts2.tags.create!(name: "#{@ts2.name}_tag#{n}")}
    @all_tags = @tags1 + @tags2
  end

  after :all do
    clean_db
  end

  before :example do
    @g = create(:gathering, campus: @ca)
  end

  it 'adds given tags' do
    @g.add_tags!(*@all_tags)
    expect(@g.has_tags?(*@all_tags)).to be true
  end

  it 'removes given tags' do
    @g.add_tags!(*@all_tags)
    @g.remove_tags!(*@tags1)
    expect(@g.has_tags?(*@tags1)).to be false
    expect(@g.has_tags?(*@tags2)).to be true
  end

  it 'removes all tags' do
    @g.add_tags!(*@all_tags)
    @g.set_tags!
    expect(@g).to_not be_is_tagged
  end

  it 'sets all tags to be those given' do
    @g.add_tags!(*@all_tags)
    @g.set_tags!(@tags2.first, @tags1.last)
    expect(@g.has_tags?(@tags2.first, @tags1.last)).to be true
    expect(@g.tags.count).to eq(2)
  end

  it 'sets tags within a tag set to be those given' do
    @g.add_tags!(*@all_tags)
    @g.set_tags!(@tags1.first, @tags1.last, @ts2.name => @ts2.tags)
    expect(@g.has_tags?(*@tags2)).to be true
    expect(@g.has_tags?(@tags1.first, @tags1.last)).to be true
    (@tags1 - [@tags1.first, @tags1.last]).each{|tag| expect(@g.has_tag?(tag)).to be false}
  end

  it 'can check if it has specific tags' do
    @g.add_tags!(*@all_tags)
    expect(@g.has_tags?(@tags1.first, @tags2.last)).to be true
  end

  it 'can check if it has no tags' do
    expect(@g.is_tagged?).to be false
  end

  it 'can check if it has any tag' do
    @g.add_tags!(*@tags1)
    expect(@g.has_tags?).to be true
    expect(@g.is_tagged?).to be true
  end

  it 'can return the available tag sets' do
    tag_sets = @g.tag_sets
    expect(tag_sets.length).to be(@c.tag_sets.length)
    expect(tag_sets.find(@ts1)).to be_present
    expect(tag_sets.find(@ts2)).to be_present
  end

  it 'returns taggings from a given tag set' do
    @g.add_tags!(*@all_tags)
    expect(@g.tags_from_set(@ts1).map{|t| t.to_s}.sort).to eq(@tags1.map{|t| t.to_s}.sort)
  end

end
