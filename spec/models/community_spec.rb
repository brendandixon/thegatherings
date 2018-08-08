# == Schema Information
#
# Table name: communities
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Community, type: :model do

  before do
    @c = build(:community)
  end

  context 'Name Validation' do
    it 'requires a name' do
      @c.name = nil
      expect(@c).to be_invalid
      expect(@c.errors).to have_key(:name)
    end

    it 'rejects short names' do
      @c.name = "short"
      expect(@c).to be_invalid
      expect(@c.errors).to have_key(:name)
    end

    it 'rejects excessively long names' do
      @c.name = "x" * 256
      expect(@c).to be_invalid
      expect(@c.errors).to have_key(:name)
    end
  end

  context 'Role Names' do

    it 'adds default role names' do
      @c.save
      @c.add_default_role_names!

      n = RoleContext::COMMUNITY_ROLES.length + RoleContext::CAMPUS_ROLES.length + RoleContext::GATHERING_ROLES.length
      expect(@c.role_names.length).to be_equal(n)
      @c.role_names.each do |rn|
        expect(rn.name).to eq(I18n.t(rn.role, scope: :roles))
      end
    end

    it 'returns Community role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Community, role: RoleContext::LEADER)

      @c.community_role_names.each do |r, n|
        if r == RoleContext::LEADER
          expect(n).to eq("FauxLeader")
        else
          expect(n).to eq(I18n.t(r, scope: :roles))
        end
      end
    end

    it 'returns Campus role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Campus, role: RoleContext::LEADER)

      @c.campus_role_names.each do |r, n|
        if r == RoleContext::LEADER
          expect(n).to eq("FauxLeader")
        else
          expect(n).to eq(I18n.t(r, scope: :roles))
        end
      end
    end

    it 'returns Gathering role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Gathering, role: RoleContext::LEADER)

      @c.gathering_role_names.each do |r, n|
        if r == RoleContext::LEADER
          expect(n).to eq("FauxLeader")
        else
          expect(n).to eq(I18n.t(r, scope: :roles))
        end
      end
    end

  end

  context 'Tag Sets' do

    before :example do
      @c.save
      @c.add_default_categories!
    end

    after :example do
      @c.destroy
    end

    it 'adds default tag sets' do
      dts = Category::DEFAULT_CATEGORIES.keys
      expect(@c.categories.size).to eq(dts.length)

      dts.each do |name|
        ts = @c.categories.with_name(name).take
        expect(ts).to be_a(Category)
        validate_default_tags(name, ts.tags)
      end
    end

    it 'removes tag sets' do
      ts1 = @c.categories.first
      ts2 = @c.categories.second
      prior = @c.categories.size
      @c.remove_categories!(ts1, ts2)
      expect(@c.categories.size).to eq(prior-2)
      expect(@c.categories.exists?(id: ts1.id)).to be false
      expect(@c.categories.exists?(id: ts2.id)).to be false
    end

    def validate_default_tags(key, actual)
      expect(actual.map{|tag| tag.name}.sort).to eq(Category::DEFAULT_CATEGORIES[key][:values].sort)
    end

  end

  it 'returns itself as its community' do
    expect(@c.community).to eq(@c)
  end

end
