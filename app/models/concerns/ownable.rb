module Ownable
  extend ActiveSupport::Concern


  included do
  end

  def for_member?(member)
    self.member_id == member.id
  end

end
