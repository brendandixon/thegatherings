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
  has_many :requests, through: :campuses
  has_many :checkups, inverse_of: :community, through: :gatherings

  has_many :memberships, as: :group, dependent: :destroy
  has_many :members, through: :memberships

  has_many :preferences, inverse_of: :community, dependent: :destroy
  has_many :requests, inverse_of: :community, dependent: :destroy
  has_many :request_owners, through: :requests, inverse_of: :community, dependent: :destroy

  has_many :role_names, dependent: :destroy
  has_many :categories, dependent: :destroy

  validates_length_of :name, within: 10..255

  def add_default_role_names!
    self.role_names.delete_all
    RoleName.add_defaults!(self)
  end

  def add_default_categories!(*categories)
    self.categories.delete_all
    Category.add_defaults!(self)
  end

  def remove_categories!(*categories)
    if categories.empty? || categories.blank?
      self.categories.delete_all
    else
      return unless categories.all?{|category| category.is_a?(Category)}
      Community.transaction do
        self.categories.delete(categories)
      end
    end
  end

  def community_role_names
    role_names_for(RoleContext::COMMUNITY_ROLES, Community)
  end

  def campus_role_names
    role_names_for(RoleContext::CAMPUS_ROLES, Campus)
  end

  def gathering_role_names
    role_names_for(RoleContext::GATHERING_ROLES, Gathering)
  end

  def campus
  end
  
  def community
    self
  end

  def meetings
    Meeting.for_community(self)
  end

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |c|
      c['campuses'] = self.campuses.as_json if options[:deep]
      c['path'] = community_path(self)
      c['campuses_path'] = community_campuses_path(self)
      c['categories_path'] = community_categories_path(self)
      c['gatherings_path'] = community_gatherings_path(self)
      c['memberships_path'] = community_memberships_path(self)
      c['preferences_path'] = community_preferences_path(self)
      c['attendees_path'] = attendees_community_path(self)
      c['health_path'] = health_community_path(self)
      c['requests_path'] = community_requests_path(self)
    end
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
