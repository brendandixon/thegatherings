class HealthRecord

  attr_reader :gathering, :start_on, :ends_on, :gather_score, :adopt_score, :shape_score, :reflect_score, :total_score

  class<<self

    def health_for(group, starts_on = nil, ends_on = nil)
      return [] unless group.present?

      ends_on ||= DateTime.current.beginning_of_week
      starts_on ||= 3.months.ago.beginning_of_week

      gatherings = group.is_a?(Gathering) ? [group] : group.gatherings
      health = []
      gatherings.each do |g|
        gs = 0
        as = 0
        ss = 0
        rs = 0
        ts = 0
        g.checkups.after(starts_on).before(ends_on).each do |c|
          gs += c.gather_score
          as += c.adopt_score
          ss += c.shape_score
          rs += c.reflect_score
          ts += c.total_score
        end
        gs = (gs.to_f / g.checkups.count).round.to_i
        as = (as.to_f / g.checkups.count).round.to_i
        ss = (ss.to_f / g.checkups.count).round.to_i
        rs = (rs.to_f / g.checkups.count).round.to_i
        ts = (ts.to_f / g.checkups.count).round.to_i
        health << HealthRecord.new(g, starts_on, ends_on, gs, as, ss, rs, ts)
      end
      health
    end

  end

  protected

    def initialize(gathering,
      starts_on,
      ends_on,
      gather_score,
      adopt_score,
      shape_score,
      reflect_score,
      total_score)
      @gathering = gathering
      @starts_on = start_on
      @ends_on = ends_on
      @gather_score = gather_score
      @adopt_score = adopt_score
      @shape_score = shape_score
      @reflect_score = reflect_score
      @total_score = total_score
    end

end
