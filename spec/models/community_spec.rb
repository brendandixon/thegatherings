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

      n = ApplicationAuthorizer::COMMUNITY_ROLES.length + ApplicationAuthorizer::CAMPUS_ROLES.length + ApplicationAuthorizer::GATHERING_ROLES.length
      expect(@c.role_names.length).to be_equal(n)
      @c.role_names.each do |rn|
        expect(rn.name).to eq(I18n.t(rn.role, scope: :roles))
      end
    end

    it 'returns Community role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Community, role: ApplicationAuthorizer::LEADER)

      @c.community_role_names.each do |r, n|
        if r == ApplicationAuthorizer::LEADER
          expect(n).to eq("FauxLeader")
        else
          expect(n).to eq(I18n.t(r, scope: :roles))
        end
      end
    end

    it 'returns Campus role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Campus, role: ApplicationAuthorizer::LEADER)

      @c.campus_role_names.each do |r, n|
        if r == ApplicationAuthorizer::LEADER
          expect(n).to eq("FauxLeader")
        else
          expect(n).to eq(I18n.t(r, scope: :roles))
        end
      end
    end

    it 'returns Gathering role names' do
      @c.save
      @c.role_names.create!(name: "FauxLeader", group_type: Gathering, role: ApplicationAuthorizer::LEADER)

      @c.gathering_role_names.each do |r, n|
        if r == ApplicationAuthorizer::LEADER
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
      @c.add_default_tag_sets!
    end

    after :example do
      @c.destroy
    end

    it 'adds default tag sets' do
      dts = TagSet::DEFAULT_TAG_SETS.keys
      expect(@c.tag_sets.size).to eq(dts.length)

      dts.each do |name|
        ts = @c.tag_sets.with_name(name).take
        expect(ts).to be_a(TagSet)
        validate_default_tags(name, ts.tags)
      end
    end

    it 'removes tag sets' do
      ts1 = @c.tag_sets.first
      ts2 = @c.tag_sets.second
      prior = @c.tag_sets.size
      @c.remove_tag_sets!(ts1, ts2)
      expect(@c.tag_sets.size).to eq(prior-2)
      expect(@c.tag_sets.exists?(id: ts1.id)).to be false
      expect(@c.tag_sets.exists?(id: ts2.id)).to be false
    end

    def validate_default_tags(key, actual)
      expect(actual.map{|tag| tag.name}.sort).to eq(TagSet::DEFAULT_TAG_SETS[key].sort)
    end

  end

  it 'returns itself as its community' do
    expect(@c.community).to eq(@c)
  end

end
