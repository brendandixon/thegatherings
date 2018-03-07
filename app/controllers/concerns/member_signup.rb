module MemberSignup
  extend ActiveSupport::Concern


  JOIN_COMMUNITY = 0
  JOIN_CAMPUS = 1
  CREATE_PREFERENCES = 2
  SET_PREFERENCES = 3
  
  included do 
  end

  class_methods do
  end

  def in_signup_for?(member)
    return true if @member_signup.present? && @member_signup[:member] == member
    return false unless cookies[:member_signup].present?

    h = JSON.parse(cookies[:member_signup])
    h.symbolize_keys!
    h[:member] = Member.find(h[:member_id])
    raise unless h[:member] == member
    if h[:community_id].present?
      h[:community] = Community.find(h[:community_id])
    else
      communities = member.memberships.in_communities
      community = communities.take if communities.length == 1
      raise unless community.present?

      h[:community] = community
      h[:community_id] = community.id
    end
    h[:step] ||= 0

    @member_signup = h
  rescue
    complete_signup
    return false
  end

  def begin_signup_for(member = current_member, community = nil)
    community ||= Community.first if Community.count == 1
    @member_signup = {}
    @member_signup[:member] = member
    @member_signup[:member_id] = member.id
    @member_signup[:community] = community
    @member_signup[:community_id] = community.id if community.present?
    @member_signup[:step] = -1
    cookies[:member_signup] = JSON.generate(@member_signup.except(:member, :community))
    signup_path_for(member)
  end

  def update_signup_for(member)
    return unless in_signup_for?(member)
    cookies[:member_signup] = JSON.generate(@member_signup.except(:member, :community))
  end

  def complete_signup
    cookies.delete :member_signup
    @member_signup = nil
  end

  def signup_path_for(member = current_member)
    community = current_member.communities.first
    path = nil
    begin
      while path.blank? && in_signup_for?(member) do
        @member_signup[:step] += 1

        raise unless @member_signup[:member] == member
        community = @member_signup[:community]
        step = @member_signup[:step]

        if step <= JOIN_COMMUNITY
          if community.present?
            member.activate!(community) if member.active_member_of(community).blank?
          else
            path = communities_path(member_id: member.id)
          end

        elsif step <= JOIN_CAMPUS
          if member.memberships.in_campuses.for_community(:campus, community).count < 1
            if community.campuses.count <= 1
              member.activate!(community.campuses.first) if community.campuses.count > 0
            else
              path = community_campuses_path(community, member_id: member.id)
            end
          end

        elsif step <= CREATE_PREFERENCES
          Preference.create(community: community, member: member, campus: member.active_campuses.first) unless member.preferences.for_community(@community).exists?

        elsif step <= (SET_PREFERENCES + @community.tag_sets.length - 1)
          preference = member.preferences.for_community(community).take
          tag_set = @community.tag_sets[step - SET_PREFERENCES]
          path = edit_preference_tags_path(preference_id: preference.id, tag_sets: tag_set.to_s)

        else
          complete_signup
        end
      end

    rescue Exception => e
      dump_exception(e)
      complete_signup
    end

    update_signup_for(member)
    path || (member.is_self?(current_member) ? member_root_path : new_community_member_path(community))
  end
end

