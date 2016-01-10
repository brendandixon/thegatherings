# == Schema Information
#
# Table name: communities
#
#  id          :string(36)       not null, primary key
#  name        :string(255)
#  active_on   :date
#  inactive_on :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Community < ActiveRecord::Base
  include UniqueID

  before_validation :ensure_active_on

  validates_presence_of :active_on

  has_many :campuses
  has_many :gatherings

  private

    def ensure_active_on
      self.active_on = DateTime.current if self.new_record?
    end
  
end
