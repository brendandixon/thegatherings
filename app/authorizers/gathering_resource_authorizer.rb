class GatheringResourceAuthorizer < ApplicationAuthorizer

  def creatable_by?(member, options = {})
    super
    acts_as_gathering_leader?
  end

  def readable_by?(member, options = {})
    super
    acts_as_gathering_member? ||
    acts_as_gathering_leader?
  end

  def updatable_by?(member, options = {})
    super
    acts_as_gathering_leader?
  end

  def deletable_by?(member, options = {})
    super
    acts_as_gathering_leader?
  end

end
