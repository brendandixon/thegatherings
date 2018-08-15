# == Schema Information
#
# Table name: campuses
#
#  id               :bigint(8)        not null, primary key
#  community_id     :bigint(8)        not null
#  name             :string(255)
#  street_primary   :string(255)
#  street_secondary :string(255)
#  city             :string(255)
#  state            :string(255)
#  country          :string(255)
#  postal_code      :string(255)
#  email            :string(255)
#  phone            :string(255)
#  primary          :boolean          default(FALSE), not null
#  active_on        :datetime
#  inactive_on      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Campus < ApplicationRecord
  include Authority::Abilities
  include ActiveDates
  include Addressed
  include Emailable
  include Joinable
  include Phoneable

  FORM_FIELDS = ADDRESS_FIELDS + EMAIL_FIELDS + PHONE_FIELDS + [:community_id, :name, :primary, :active_on, :inactive_on]

  belongs_to :community, inverse_of: :campuses

  has_many :gatherings, inverse_of: :campus, dependent: :restrict_with_exception

  has_many :memberships, as: :group, dependent: :destroy
  has_many :members, through: :memberships
  has_many :assigned_overseers, through: :memberships

  has_many :preferences, inverse_of: :campus, dependent: :nullify
  has_many :requests, inverse_of: :campus, dependent: :destroy

  validates :community, belonging: {models: [Community]}
  validates_length_of :name, within: 4..255

  scope :for_community, lambda{|community| where(community: community)}

  def campus
    self
  end

  def meetings
    Meeting.for_campus(self)
  end

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |c|
      c['gatherings'] = self.gatherings.as_json if options[:deep]
      c['path'] = campus_path(self)
      c['community_path'] = community_path(self.community)
      c['gatherings_path'] = campus_gatherings_path(self)
      c['memberships_path'] = campus_memberships_path(self)
      c['requests_path'] = campus_requests_path(self)
    end
  end

  def to_s
    self.name
  end

end
