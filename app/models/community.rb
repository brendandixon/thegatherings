# == Schema Information
#
# Table name: communities
#
#  id          :bigint(8)        not null, primary key
#  name        :string(255)
#  active_on   :datetime         not null
#  inactive_on :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Community < ApplicationRecord
  include Authority::Abilities
  include ActiveDates
  include Joinable

  FORM_FIELDS = [:name, :active_on, :inactive_on]

  has_many :campuses, inverse_of: :community, dependent: :restrict_with_exception
  has_many :gatherings, through: :campuses

  has_many :memberships, as: :group, dependent: :destroy
  has_many :members, through: :memberships

  has_many :preferences, inverse_of: :community, dependent: :destroy

  has_many :role_names, dependent: :destroy
  has_many :tag_sets, dependent: :destroy

  validates_length_of :name, within: 10..255

  def add_default_role_names!
    self.role_names.delete_all
    RoleName.add_defaults!(self)
  end

  def add_default_tag_sets!(*tag_sets)
    self.tag_sets.delete_all
    TagSet.add_defaults!(self)
  end

  def remove_tag_sets!(*tag_sets)
    if tag_sets.empty? || tag_sets.blank?
      self.tag_sets.delete_all
    else
      return unless tag_sets.all?{|tag_set| tag_set.is_a?(TagSet)}
      Community.transaction do
        self.tag_sets.delete(tag_sets)
      end
    end
  end

  def community_role_names
    role_names_for(ApplicationAuthorizer::COMMUNITY_ROLES, Community)
  end

  def campus_role_names
    role_names_for(ApplicationAuthorizer::CAMPUS_ROLES, Campus)
  end

  def gathering_role_names
    role_names_for(ApplicationAuthorizer::GATHERING_ROLES, Gathering)
  end

  def campus
  end
  
  def community
    self
  end

  def meetings
    Meeting.for_community(self)
  end

  def to_s
    self.name
  end

  protected

    def role_names_for(roles, group)
      rn = {}

      roles.each do |role|
        n = self.role_names.for_group(group).for_role(role).take
        rn[role] = n.present? ? n.name : I18n.t(role, scope: :roles)
      end

      rn
    end
  
end
