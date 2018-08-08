# == Schema Information
#
# Table name: taggings
#
#  id            :bigint(8)        unsigned, not null, primary key
#  tag_id        :bigint(8)
#  taggable_id   :bigint(8)        unsigned, not null
#  taggable_type :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

describe Tagging, type: :model do

  before :example do
    @c = create(:community)
    @ca = create(:campus, community: @c)
    @g = create(:gathering, campus: @ca)
    @m = create(:member)
    @p = create(:preference, community: @c, member: @m)
    @ts1 = create(:category, community: @c)
    @ts2 = create(:category, community: @c, singleton: true)
    @tags1 = (0..6).inject([]) {|tags, i| tags << create(:tag, category: @ts1); tags }
    @tags2 = (0..6).inject([]) {|tags, i| tags << create(:tag, category: @ts2); tags }
    @tagging = build(:tagging, tag: @tags1.first, taggable: @g)
  end

  it 'validates' do
    expect(@tagging).to be_valid
    expect(@tagging.errors).to be_empty
  end

  it 'requires a tag' do
    @tagging.tag = nil
    expect(@tagging).to be_invalid
    expect(@tagging.errors).to have_key(:tag)
  end

  it 'requires a taggable' do
    @tagging.taggable = nil
    expect(@tagging).to be_invalid
    expect(@tagging.errors).to have_key(:taggable)
  end

  it 'allows tagging Gatherings' do
    @tagging.taggable = @g
    expect(@tagging).to be_valid
    expect(@tagging.errors).to be_empty
  end

  it 'allows tagging Prefence' do
    @tagging.taggable = @p
    expect(@tagging).to be_valid
    expect(@tagging.errors).to be_empty
  end

  it 'rejects taggables that are not a Gathering or Membership' do
    expect { @tagging.taggable = build(:campus) }.to raise_error(ActiveRecord::InverseOfAssociationNotFoundError)
  end

  it 'allows multiple tags from the same tag set' do
    @tagging.save!
    @tagging = build(:tagging, tag: @tags1.second, taggable: @g)
    expect(@tagging).to be_valid
    expect(@tagging.errors).to be_empty
  end

  it 'rejects multiple singleton tags' do
    create(:tagging, tag: @tags2.first, taggable: @g)
    @tagging = build(:tagging, tag: @tags2.second, taggable: @g)
    expect(@tagging).to_not be_valid
    expect(@tagging.errors).to have_key(:tag)
  end

end
