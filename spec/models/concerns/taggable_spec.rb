require "rails_helper"

class TagsModelMigration < ActiveRecord::Migration
  def up
    create_table :tags_models
  end

  def down
    drop_table :tags_models
  end
end

class TagsModel < ActiveRecord::Base
  include Taggable
end

describe Taggable, type: :concern do
  @verbosity = true

  before :all do
    @verbosity = ActiveRecord::Migration.verbose
    ActiveRecord::Migration.verbose = false
    TagsModelMigration.new.up
  end

  after :all do
    TagsModelMigration.new.down
    ActiveRecord::Migration.verbose = @verbosity
  end

  before :example do
    @tm = TagsModel.new
  end

  it 'to_tags returns an empty list for unknown tag sets' do
    expect(Taggable.to_tags('no_a_tag_set', 'value1')).to be_empty
  end

  it 'to_tags rejects unrecognized tags' do
    expect(Taggable.to_tags('age_group', 'badvalue', 'morebad')).to be_empty
  end

  it 'to_tags accepts unrecognized tags' do
    expect(Taggable.to_tags('age_group', 'twenties', 'thirties').length).to be(2)
  end

  it 'is_tagged? returns false if tags are missing' do
    expect(@tm).to_not be_is_tagged
  end

  it 'is_tagged? returns true if all tag categories have at least one tag' do
    Taggable::TAGS.each do |tag|
      @tm.send("#{tag}_list=", "Taggable::#{tag.classify.pluralize}".constantize::VALUES.first)
    end
    expect(@tm).to be_is_tagged
  end

  it 'fails validation all tag groups' do
    Taggable::TAGS.each do |tag|
      @tm.send("#{tag}_list=", "not a legal tag value")
    end
    expect(@tm).to be_invalid
    Taggable::TAGS.each do |tag|
      expect(@tm.errors).to have_key("#{tag}_list".to_sym)
    end
  end

  it 'fails validation all tag groups' do
    Taggable::TAGS.each do |tag|
      @tm.send("#{tag}_list=", "Taggable::#{tag.classify.pluralize}".constantize::VALUES.first)
    end
    expect(@tm).to be_valid
    Taggable::TAGS.each do |tag|
      expect(@tm.errors).to_not have_key("#{tag}_list".to_sym)
    end
  end

end
