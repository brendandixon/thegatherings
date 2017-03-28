module MemberSignup
  extend ActiveSupport::Concern

  PHASES = %w(join_community) + Taggable::TAGS + %w(join_campus)

  included do 
  end

  class_methods do
  end

  def in_member_signup?
    return true if @member_signup.present?
    return false unless cookies[:member_signup].present?

    h = JSON.parse(cookies[:member_signup])
    h.symbolize_keys!
    h[:member] = Member.find(h[:member_id])
    if h[:community_id].present?
      h[:community] = Community.find(h[:community_id])
    else
      communities = member.memberships.in_communities
      community = communities.take if communities.length == 1
      if community.present?
        h[:community] = community
        h[:community_id] = community.id
      else
        complete_member_signup
        return false
      end
    end
    h[:phase_index] ||= 0

    @member_signup = h
  rescue
    complete_member_signup
    return false
  end

  def begin_member_signup(member = current_member, community = nil)
    community ||= Community.first if Community.count == 1
    @member_signup = {}
    @member_signup[:member] = member
    @member_signup[:member_id] = member.id
    @member_signup[:community] = community
    @member_signup[:community_id] = community.id if community.present?
    @member_signup[:phase_index] = -1
    cookies[:member_signup] = JSON.generate(@member_signup.except(:member, :community, :phase))
    member_signup_path
  end

  def continue_member_signup
    return unless in_member_signup?
    @member_signup[:phase_index] += 1
  end

  def update_member_signup
    return unless in_member_signup?
    cookies[:member_signup] = JSON.generate(@member_signup.except(:member, :community, :phase))
  end

  def complete_member_signup
    cookies.delete :member_signup
    @member_signup = nil
  end

  def member_signup_path
    path = nil
    begin
      while path.blank? && in_member_signup? do
        continue_member_signup
        
        member = @member_signup[:member]
        community = @member_signup[:community]
                
        @member_signup[:phase] = PHASES[@member_signup[:phase_index]]
        case @member_signup[:phase]

        when 'join_community'
          if community.present?
            member.join!(community) if member.membership_in(community).blank?
          else
            path = communities_path(member_id: member.id)
          end

        when *Taggable::TAGS
          community_membership = member.membership_in(community)
          tags = @member_signup[:phase]
          path = edit_membership_tags_path(community_membership, member_id: member.id, tags: tags)

        when 'join_campus'
          if member.memberships.in_campuses.for_community(:campus, community).count < 1
            if community.campuses.count <= 1
              member.join!(community.campuses.first) if community.campuses.count > 0
            else
              path = community_campuses_path(community, member_id: member.id)
            end
          end

        else
          complete_member_signup
          path = member.is_self?(current_member) ? member_root_path : community_member_path(community, member)
        end
      end

    rescue Exception => e
      complete_member_signup
      path = member_root_path
    end

    update_member_signup
    path
  end
end
