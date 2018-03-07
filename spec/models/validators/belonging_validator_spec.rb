require "rails_helper"

class UnknownModel < TestModelBase
  define_attribute :unused
end

class BelongingModelOwner1 < TestModelBase
  define_attribute :unused
end

class BelongingModelOwner2 < TestModelBase
  define_attribute :unused
end

class BelongingModelOwner3 < TestModelBase
  define_attribute :unused
end

class BelongingModel < TestModelBase
  define_attribute :model
  define_attribute :model_blank
  define_attribute :model_new

  validates :model, belonging: {models: [BelongingModelOwner1, BelongingModelOwner2, BelongingModelOwner3]}
  validates :model_blank, belonging: {allow_blank: true, models: [BelongingModelOwner1, BelongingModelOwner2, BelongingModelOwner3]}
  validates :model_new, belonging: {allow_blank: true, allow_new: true}
end

describe BelongingValidator, type: :validator do

  before :example do
    bmo = BelongingModelOwner1.new
    bmo.save
    @bm = BelongingModel.new(
        model: bmo,
        model_blank: bmo,
        model_new: bmo
      )
  end

  it 'requires a known model' do
    @bm.model = UnknownModel.new
    expect(@bm).to be_invalid
    expect(@bm.errors).to have_key(:model)
  end

  it 'accepts a known model' do
    expect(@bm).to be_valid
    expect(@bm.errors).to_not have_key(:model)
  end

  it 'allows blank if requested' do
    @bm.model_blank = nil
    expect(@bm).to be_valid
    expect(@bm.errors).to_not have_key(:model_blank)
  end

  it 'requires a saved model if requested' do
    @bm.model = BelongingModelOwner1.new
    expect(@bm).to be_invalid
    expect(@bm.errors).to have_key(:model)
  end

  it 'accepts a new model if allowed' do
    @bm.model_new = BelongingModelOwner1.new
    expect(@bm).to be_valid
    expect(@bm.errors).to_not have_key(:model_new)
  end

end
