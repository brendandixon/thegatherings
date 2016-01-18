# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Time.use_zone "Pacific Time (US & Canada)" do

  Community.create({name: "Bethany Community Church"})
  bcc = Community.first

  Campus.create({
    community: bcc,
    name: "Bethany Greenlake",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    street_primary: "8023 Green Lake Dr N",
    city: "Seattle",
    state: "WA",
    postal_code: "98103",
    time_zone: Time.zone.name
  })
  Campus.create({
    community: bcc,
    name: "Bethany North",
    phone: "206.316.8377",
    email: "north@churchbcc.org",
    street_primary: "16743 Aurora Ave. N.",
    city: "Shoreline",
    state: "WA",
    postal_code: "98133",
    time_zone: Time.zone.name
  })
  Campus.create({
    community: bcc,
    name: "Bethany West Seattle",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    time_zone: Time.zone.name
  })
  Campus.create({
    community: bcc,
    name: "Bethany Northeast",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    time_zone: Time.zone.name
  })
  Campus.create({
    community: bcc,
    name: "Bethany Ballard",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    street_primary: "8023 Green Lake Dr N",
    city: "Seattle",
    state: "WA",
    postal_code: "98103",
    time_zone: Time.zone.name
  })
  Campus.create({
    community: bcc,
    name: "Bethany Eastside",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    street_primary: "8023 Green Lake Dr N",
    city: "Seattle",
    state: "WA",
    postal_code: "98103",
    time_zone: Time.zone.name
  })

  options = {
              community: bcc,
              street_primary: "3302 NW 73rd Street",
              city: "Seattle",
              state: "WA",
              postal_code: "98117",
              meeting_starts: 'January 12, 2016',
            }
  Gathering.create!({name: 'Ballard Small Group', description: "The Ballard Small Group gathering.", meeting_day: 'thursday'}.merge(options)) do |g|
      g.age_group_list = 'age_group_thirties, age_group_forties, age_group_fifties, age_group_sixties'
      g.life_stage_list = 'life_stage_established_career, life_stage_post_career'
      g.relationship_list = 'relationship_established_family, relationship_empty_nester, relationship_divorced'
      g.gender_list = 'gender_mixed'
  end
  Gathering.create!({name: 'Ballard PCEC', description: "The Ballard PCEC gathering.", meeting_day: 'tuesday'}.merge(options)) do |g|
      g.age_group_list = 'age_group_twenties, age_group_thirties'
      g.life_stage_list = 'life_stage_post_college, life_stage_early_career'
      g.relationship_list = 'relationship_single'
      g.gender_list = 'gender_women'
  end

  options = {
    time_zone: Time.zone.name
  }
  ['Brendan Dixon', 'Kim Dixon', 'Carl Janzen', 'Nicole Janzen', 'Irene McKillop', 'Patrick Miller', 'Amy Miller'].each_with_index do |n, i|
    f, l = n.split(' ')
    Member.create!({first_name: f, last_name: l, email: "#{f}.#{l}@nomail.com", phone: "425.123.100#{i}", postal_code: "9811#{i}"}.merge(options)) do |m|
      m.age_group_list = 'age_group_thirties, age_group_forties, age_group_fifties, age_group_sixties'
      m.life_stage_list = 'life_stage_established_career, life_stage_post_career'
      m.relationship_list = 'relationship_established_family, relationship_empty_nester, relationship_divorced'
      m.gender_list = 'gender_mixed'
    end
  end

  ['Jordan Conrad', 'Tiffany Dimaculangan', 'Lauren Heerlein', 'Chelsea Heimbigner', 'Melissa Howard', 'Abby Lombardo', 'Kristin Mendoza'].each_with_index do |n, i|
    f, l = n.split(' ')
    Member.create!({first_name: f, last_name: l, email: "#{f}.#{l}@nomail.com", phone: "425.123.200#{i}", postal_code: "9812#{i}"}.merge(options)) do |m|
      m.age_group_list = 'age_group_twenties, age_group_thirties'
      m.life_stage_list = 'life_stage_post_college, life_stage_early_career'
      m.relationship_list = 'relationship_single'
      m.gender_list = 'gender_women'
    end
  end

end
