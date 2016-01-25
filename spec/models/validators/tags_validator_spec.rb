require "rails_helper"

class TagsValidatorModel < FauxModel
  TAGS = %w(tag0 tag1 tag2 tag3 tag4 tag5 tag6 tag7 tag8 tag9)
  define_tags :tags, :tags_blank, :tags_limit
  validates :tags_list, tags: {values: TAGS}
  validates :tags_blank_list, tags: {allow_blank: true, values: TAGS}
  validates :tags_limit_list, tags: {limit: 2, values: TAGS}
end

describe TagsValidator, type: :validator do

  before :example do
    @tvm = TagsValidatorModel.new(
        tags_list: %w(tag0 tag1 tag2 tag3 tag4),
        tags_blank_list: %w(tag0 tag1),
        tags_limit_list: %w(tag0 tag1)
      )
  end

  it 'accepts legal tags' do
    expect(@tvm).to be_valid
    expect(@tvm.errors).to_not have_key(:tags_list)
  end

  it 'rejects unexpected tags' do
    @tvm.tags_list = %w(foo bar)
    expect(@tvm).to be_invalid
    expect(@tvm.errors).to have_key(:tags_list)
  end

  it 'requires tags if requested' do
    @tvm.tags_list = nil
    expect(@tvm).to be_invalid
    expect(@tvm.errors).to have_key(:tags_list)
  end

  it 'does not requires tags if requested' do
    @tvm.tags_blank_list = nil
    expect(@tvm).to be_valid
    expect(@tvm.errors).to_not have_key(:tags_blank_list)
  end

  it 'limits the number of tags if requested' do
    @tvm.tags_limit_list = %w(tag0 tag1, tag2)
    expect(@tvm).to be_invalid
    expect(@tvm.errors).to have_key(:tags_limit_list)
  end

end
