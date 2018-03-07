require "rails_helper"

class QueryHelpersModel < TestModelBase
  include QueryHelpers

  define_attribute :unused
end

describe QueryHelpers, type: :concern do

  before :example do
    @qhm = QueryHelpersModel.new
  end

  context 'to_bool' do
    it 'converts true values to true' do
      %w(true t yes y).each do |v|
        expect(@qhm.to_bool(v)).to be_truthy
      end
    end

    it 'converts false values to false' do
      %w(false f no n).each do |v|
        expect(@qhm.to_bool(v)).to be_falsey
      end
    end

    it 'converts any other value to false' do
      expect(@qhm.to_bool('foo bar')).to be_falsey
    end
  end

  context 'to_days' do
    it 'converts Mondays to the correct day' do
      %w(monday mon).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:monday])
      end
    end

    it 'converts Tuesdays to the correct day' do
      %w(tuesday tues).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:tuesday])
      end
    end

    it 'converts Wednesdays to the correct day' do
      %w(wednesday wed).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:wednesday])
      end
    end

    it 'converts Thursdays to the correct day' do
      %w(thursday thurs).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:thursday])
      end
    end

    it 'converts Fridays to the correct day' do
      %w(friday fri).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:friday])
      end
    end

    it 'converts Saturdays to the correct day' do
      %w(saturday sat).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:saturday])
      end
    end

    it 'converts Sundays to the correct day' do
      %w(sunday sun).each do |v|
        expect(@qhm.to_days(v).first).to eq(DateTime::DAYS_INTO_WEEK[:sunday])
      end
    end

    it 'converts multiple days correctly' do
      expect(@qhm.to_days('monday,friday')).to match_array([DateTime::DAYS_INTO_WEEK[:monday], DateTime::DAYS_INTO_WEEK[:friday]])
    end

    it 'ignores values that are not days' do
      expect(@qhm.to_days('baz,monday,foo,friday,bar')).to match_array([DateTime::DAYS_INTO_WEEK[:monday], DateTime::DAYS_INTO_WEEK[:friday]])
    end
  end

  context 'to_time_range' do
    it 'converts morning to 6am through noon' do
      expect(@qhm.to_time_range('morning')).to eq(6.hours..12.hours)
    end

    it 'converts afternoon to noon through 5pm' do
      expect(@qhm.to_time_range('afternoon')).to eq(12.hours..17.hours)
    end

    it 'converts evening to 5pm through 10pm' do
      expect(@qhm.to_time_range('evening')).to eq(17.hours..22.hours)
    end

    it 'returns nil for any other value' do
      expect(@qhm.to_time_range('foo')).to be_nil
    end
  end

end
