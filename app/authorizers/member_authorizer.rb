class MemberAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    (belongs_to_community? && acts_as_community_member?) ||
    (belongs_to_campus? && acts_as_campus_member?) ||
    (belongs_to_gathering? && acts_as_gathering_leader?)
  end

  def readable_by?(member, options = {})
    super
    is_self?(member) ||
    (belongs_to_community? &&
      (acts_as_community_leader? ||
        ((as_anyone? || as_member?) && acts_as_community_member?))) ||
    (belongs_to_campus? &&
      (acts_as_campus_leader? ||
        ((as_anyone? || as_member?) && acts_as_campus_member?))) ||
    (belongs_to_gathering? &&
      (acts_as_gathering_leader? ||
        ((as_anyone? || as_member?) && acts_as_gathering_member?)))
  end

  def updatable_by?(member, options = {})
    super
    is_self?(member) ||
    (belongs_to_community? && acts_as_community_leader?) ||
    (belongs_to_campus? && acts_as_campus_leader?) ||
    (belongs_to_gathering? && acts_as_gathering_leader?)
  end

  def deletable_by?(member, options = {})
    super
    is_self?(member) ||
    (belongs_to_community? && acts_as_community_leader?) ||
    (belongs_to_campus? && acts_as_campus_leader?) ||
    (belongs_to_gathering? && acts_as_gathering_leader?)
  end

  protected

    def is_self?(member)
      member.id == resource.id
    end

    def belongs_to_community?
      (!resource.persisted? || (@community.present? && resource.active_member_of(@community).present?))
    rescue
      false
    end

    def belongs_to_campus?
      (!resource.persisted? || (@campus.present? && resource.active_member_of(@campus).present?))
    rescue
      false
    end

    def belongs_to_gathering?
      (!resource.persisted? || (@gathering.present? && resource.active_member_of(@gathering).present?))
    rescue
      false
    end

end
