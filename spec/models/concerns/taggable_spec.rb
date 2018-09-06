require "rails_helper"

describe Taggable, type: :concern do

  before :all do
    @c = create(:community)
    @ca = create(:campus, community: @c)

    @cat1 = @c.categories.create!(name: "category1")
    @cat2 = @c.categories.create!(name: "category2")

    @tags1 = (0..2).map{|n| @cat1.tags.create!(name: "#{@cat1.name}_tag#{n}")}
    @tags2 = (0..2).map{|n| @cat2.tags.create!(name: "#{@cat2.name}_tag#{n}")}
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
    @g.set_tags!(@tags1.first, @tags1.last, @cat2.name => @cat2.tags)
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

  it 'can return the available tag categories' do
    categories = @g.categories
    expect(categories.length).to be(@c.categories.length)
    expect(categories.find(@cat1)).to be_present
    expect(categories.find(@cat2)).to be_present
  end

  it 'returns taggings from a given tag category' do
    @g.set_tags!(@tags1.first, @tags1.last, @tags2.first, @tags2.last)
    expect(@g.tags_for(@cat1).sort).to eq([@tags1.first, @tags1.last].sort)
  end

end
