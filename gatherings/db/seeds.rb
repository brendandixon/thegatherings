# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Time.use_zone "Pacific Time (US & Canada)" do
  options = {
    active_on: DateTime.current,
    street_primary: "3302 NW 73rd Street",
    city: "Seattle",
    state: "WA",
    postal_code: "98117",
    time_zone: Time.zone.name
  }

  Community.create({name: "Bethany Greenlake"}.merge(options))
  Community.create({name: "Bethany Ballard"}.merge(options))
  Community.create({name: "Bethany Northshore"}.merge(options))

  options.delete(:active_on)
  options = options.merge({
              community_id: Community.find_by(name: "Bethany Ballard").id,
              meeting_starts: 'January 12, 2016',
            })
  Gathering.create({name: 'Ballard Small Group', description: "The Ballard Small Group gathering.", meeting_day: 'thursday'}.merge(options)) do |g|
      g.age_group_list = 'thirties, forties, fifties, sixties'
      g.life_stage_list = 'established_career, post_career'
      g.relationship_list = 'established_family, empty_nester, divorced'
      g.gender_list = 'mixed'
  end
  Gathering.create({name: 'Ballard PCEC', description: "The Ballard PCEC gathering.", meeting_day: 'tuesday'}.merge(options)) do |g|
      g.age_group_list = 'twenties, thirties'
      g.life_stage_list = 'post_college, early_career'
      g.relationship_list = 'single'
      g.gender_list = 'women_only'
  end

  options = {
    time_zone: Time.zone.name
  }
  ['Brendan Dixon', 'Kim Dixon', 'Carl Janzen', 'Nicole Janzen', 'Irene McKillop', 'Patrick Miller', 'Amy Miller'].each_with_index do |n, i|
    f, l = n.split(' ')
    Member.create({first_name: f, last_name: l, email: "#{f}.#{l}@nomail.com", phone: "425.123.100#{i}", postal_code: "9811#{i}"}.merge(options)) do |m|
      m.age_group_list = 'thirties, forties, fifties, sixties'
      m.life_stage_list = 'established_career, post_career'
      m.relationship_list = 'established_family, empty_nester, divorced'
      m.gender_list = 'mixed'
    end
  end

  ['Jordan Conrad', 'Tiffany Dimaculangan', 'Lauren Heerlein', 'Chelsea Heimbigner', 'Melissa Howard', 'Abby Lombardo', 'Kristin Mendoza'].each_with_index do |n, i|
    f, l = n.split(' ')
    Member.create({first_name: f, last_name: l, email: "#{f}.#{l}@nomail.com", phone: "425.123.200#{i}", postal_code: "9812#{i}"}.merge(options)) do |m|
      m.age_group_list = 'twenties, thirties'
      m.life_stage_list = 'post_college, early_career'
      m.relationship_list = 'single'
      m.gender_list = 'women_only'
    end
  end

end

  # LIFE_STAGES = [
  #   'college',
  #   'post_college',
  #   'early_career',
  #   'established_career',
  #   'post_career'
  # ]
  # AGE_GROUPS = [
  #   'twenties',
  #   'thirties',
  #   'forties',
  #   'fifties',
  #   'sixties',
  #   'plus'
  # ]
  # RELATIONSHIPS = [
  #   'single',
  #   'young_married',
  #   'early_family',
  #   'established_family',
  #   'empty_nester',
  #   'divorced'
  # ]
  # GENDERS = [
  #   'men_only',
  #   'women_only',
  #   'mixed'
  # ]
