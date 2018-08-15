class Mode

  MODES = [:admin, :gathering, :member]

  def initialize(member, community = nil, mode = :member)
    @dt = DateTime.current
    @member = member
    @community = community || @member.default_community
    
    mode = (mode || '').downcase.to_sym
    @mode = MODES.include?(mode) ? mode : :member
  end

  def campuses(mode = nil)
    case mode || @mode
      when :admin
        m = @community.memberships.for_member(@member).active_on(@dt).take
        return @community.campuses if m.present? && m.as_leader?

        return @community.campuses.select do |campus|
          m = campus.memberships.for_member(@member).active_on(@dt).take
          m.present? && (m.as_leader? || m.as_overseer?)
        end

      else
        return @community.campuses.select do |campus|
          campus.is_active_member?(@member, @dt)
        end
    end
  end

  def gatherings(campus = nil, mode = nil)
    campuses = campus.present? ? [campus] : self.campuses

    case mode || @mode
      when :admin
        m = @community.memberships.for_member(@member).active_on(@dt).take
        return campuses.inject([]) do |gatherings, campus|
          gatherings += campus.gatherings
          gatherings
        end

        return campuses.inject([]) do |gatherings, campus|
          m = campus.memberships.for_member(@member).active_on(@dt).take
          if m.present? && m.as_leader?
            gatherings += campus.gatherings
          else
            gatherings += campus.gatherings.select{|g| g.is_active_assigned_overseer?(@member, @dt)}
          end
          gatherings
        end

      when :gathering
        return campuses.inject([]) do |gatherings, campus|
          gatherings += campus.gatherings.select do |g|
            g.is_active_leader?(@member, @dt) ||
            g.is_active_assigned_overseer?(@member, @dt)
          end
          gatherings
        end

      else
        return campuses.inject([]) do |gatherings, campus|
          gatherings += campus.gatherings.select{|g| g.is_active_member?(@member, @dt)}
          gatherings
        end
    end
  end

  def in_admin_mode?
    @mode == :admin
  end

  def in_gathering_mode?
    @mode == :gathering
  end

  def in_member_mode?
    @mode == :member
  end

  def is_allowed?(campus = nil, mode = nil)
    case (mode || @mode)
    when :admin then return self.campuses(mode).present?
    when :member then return true
    when :gathering then return self.gatherings(campus, mode).present?
    end
  end

  def to_s
    @mode.to_s
  end

end
