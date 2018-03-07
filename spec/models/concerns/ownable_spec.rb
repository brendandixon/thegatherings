require "rails_helper"

class OwnableModel < TestModelBase
  include Ownable

  define_attribute :member_id, :integer
end

describe Ownable, type: :concern do

  before :all do
    @om = OwnableModel.new
    @member = create(:member)
  end

  after :all do
    Member.delete_all
  end

  it 'for_member returns true for the owned member' do
    @om.member_id = @member.id
    expect(@om).to be_for_member(@member)
  end

  it 'for_member returns false for the owned member' do
    @om.member_id = @member.id + 42
    expect(@om).to_not be_for_member(@member)
  end

end
