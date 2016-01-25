# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Time.use_zone "Pacific Time (US & Canada)" do

  bcc = Community.create!({name: "Bethany Community Church"})

  green = Campus.create!({
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
  north = Campus.create!({
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
  west = Campus.create!({
    community: bcc,
    name: "Bethany West Seattle",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    street_primary: "8023 Green Lake Dr N",
    city: "Seattle",
    state: "WA",
    postal_code: "98103",
    time_zone: Time.zone.name
  })
  northeast = Campus.create!({
    community: bcc,
    name: "Bethany Northeast",
    phone: "206.524.9000",
    email: "staff@churchbcc.org",
    street_primary: "8023 Green Lake Dr N",
    city: "Seattle",
    state: "WA",
    postal_code: "98103",
    time_zone: Time.zone.name
  })
  ballard = Campus.create!({
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
  east = Campus.create!({
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
              campus: ballard,
              street_primary: "3302 NW 73rd Street",
              city: "Seattle",
              state: "WA",
              postal_code: "98117",
              meeting_starts: 'January 12, 2016',
            }
  sg = Gathering.create!({name: 'Ballard Small Group', description: "The Ballard Small Group gathering.", meeting_day: 3}.merge(options)) do |g|
    g.age_group_list = 'thirties, forties, fifties, sixties'
    g.life_stage_list = 'established_career, post_career'
    g.relationship_list = 'established_family, empty_nester, divorced'
    g.gender_list = 'mixed'
  end
  pcec = Gathering.create!({name: 'Ballard PCEC', description: "The Ballard PCEC gathering.", meeting_day: 1}.merge(options)) do |g|
    g.age_group_list = 'twenties, thirties'
    g.life_stage_list = 'post_college, early_career'
    g.relationship_list = 'single'
    g.gender_list = 'women'
  end

  options = {
    time_zone: Time.zone.name
  }
  ['Brendan Dixon', 'Kim Dixon', 'Carl Janzen', 'Nicole Janzen', 'Patrick Miller', 'Irene McKillop', 'Kyle Hepper', 'Amy Miller', 'Michael McGinley', 'Rhonda McGinley'].each_with_index do |n, i|
    f, l = n.split(' ')
    m = Member.create!({first_name: f, last_name: l, gender: i.odd? ? 'female' : 'male', email: "#{f}.#{l}@nomail.com", phone: "425.123.100#{i}", postal_code: "9811#{i}"}.merge(options))
    [bcc, ballard, sg].each_with_index do |g, i|
      Membership.create!(group: g, member: m, participant: :member, active_on: DateTime.current, role: i == 0 ? 'administrator' : nil) do |mm|
        if i == 0
          mm.age_group_list = 'thirties, forties, fifties, sixties'
          mm.life_stage_list = 'established_career, post_career'
          mm.relationship_list = 'established_family, empty_nester, divorced'
          mm.gender_list = 'mixed'
        end
      end
    end
  end

  ['Jordan Conrad', 'Tiffany Dimaculangan', 'Lauren Heerlein', 'Chelsea Heimbigner', 'Melissa Howard', 'Abby Lombardo', 'Kristin Mendoza'].each_with_index do |n, i|
    f, l = n.split(' ')
    m = Member.create!({first_name: f, last_name: l, gender: 'female', email: "#{f}.#{l}@nomail.com", phone: "425.123.200#{i}", postal_code: "9812#{i}"}.merge(options))
    [bcc, green, pcec].each_with_index do |g, i|
      Membership.create!(group: g, member: m, participant: :member, active_on: DateTime.current) do |mm|
        mm.age_group_list = 'twenties, thirties'
        mm.life_stage_list = 'post_college, early_career'
        mm.relationship_list = 'single'
        mm.gender_list = 'women'
      end
    end
  end

end
