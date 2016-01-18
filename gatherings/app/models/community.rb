# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Community < ActiveRecord::Base

  has_many :campuses
  has_many :gatherings
  has_many :community_members
  has_many :members, through: :community_members

  before_validation :ensure_active_on

  validates_datetime :active_on
  validates_datetime :inactive_on, after: :active_on, allow_blank: true

  private

    def ensure_active_on
      self.active_on = DateTime.current if self.new_record?
    end
  
end
