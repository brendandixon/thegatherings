# == Schema Information
#
# Table name: members
#
#  id                     :bigint(8)        not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  gender                 :string(25)       default(""), not null
#  street_primary         :string(255)
#  street_secondary       :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  postal_code            :string(255)
#  email                  :string(255)
#  phone                  :string(255)
#  time_zone              :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Member < ApplicationRecord
  include Authority::UserAbilities
  include Authority::Abilities
  include Addressed
  include Emailable
  include InTimeZone
  include Phoneable

  GENDERS = %w(female male)

  FORM_FIELDS = ADDRESS_FIELDS + EMAIL_FIELDS + PHONE_FIELDS + TIME_ZONE_FIELDS + [:first_name, :last_name, :gender]
  JSON_EXCLUDES = JSON_EXCLUDES + %w(
    encrypted_password
    reset_password_token
    reset_password_sent_at
    remember_created_at
    sign_in_count
    current_sign_in_at
    last_sign_in_at
    current_sign_in_ip
    last_sign_in_ip
    confirmation_token
    confirmed_at
    confirmation_sent_at
    unconfirmed_email
    failed_attempts
    unlock_token
    locked_at
    provider
    uid
  )

  has_many :memberships, inverse_of: :member, dependent: :destroy
  has_many :communities, through: :memberships, source: :group, source_type: "Community"
  has_many :campuses, through: :memberships, source: :group, source_type: "Campus"
  has_many :gatherings, through: :memberships, source: :group, source_type: "Gathering"
  has_many :preferences, inverse_of: :member, dependent: :destroy
  
  has_many :attendance_records, through: :memberships, dependent: :destroy
  has_many :requests, inverse_of: :member, dependent: :destroy

  before_validation :ensure_password

  validates_length_of :first_name, within: 1..255
  validates_length_of :last_name, within: 1..255
  validates_inclusion_of :gender, in: GENDERS

  devise :database_authenticatable,
    :lockable,
    :registerable,
    :recoverable,
    :rememberable,
    :timeoutable,
    :trackable
    # :confirmable,
    # :validatable,
    # :omniauthable, :omniauth_providers => [:developer]

  def activate!(grantor, group, role = nil)
    Membership.activate!(grantor, group, self, role)
  end

  def become!(grantor, group, role)
    Membership.become!(grantor, group, self, role)
  end

  def join!(group, role = nil)
    Membership.join!(group, self, role)
  end

  def assistant_for?(group)
    m = active_member_of?(group)
    m.present? && m.as_assistant?
  end

  def leader_of?(group)
    m = active_member_of?(group)
    m.present? && m.as_leader?
  end

  def member_of?(group)
    active_member_of?(group).present?
  end

  def participant_in?(group)
    m = active_member_of?(group)
    m.present? && m.as_participant?
  end

  def visitor_to?(group)
    m = active_member_of?(group)
    m.present? && m.as_visitor?
  end

  def active_community_memberships
    self.memberships.in_communities.is_active
  end

  def active_campus_memberships
    self.memberships.in_campuses.is_active
  end

  def active_gathering_memberships
    self.memberships.in_gatherings.is_active
  end

  def default_community
    m = self.active_community_memberships.first
    m.community if m.present?
  end

  def default_campus(community)
    p = self.preferences.for_community(community).first
    return p.campus if p.present? && p.campus.present?
    m = self.active_campus_memberships.first
    m.campus if m.present?
  end

  def default_gathering(community)
    p = self.preferences.for_community(community).first
    return p.gathering if p.present? && p.gathering.present?
    m = self.active_gathering_memberships.first
    m.gathering if m.present?
  end

  def active_member_of?(group)
    self.memberships.for_group(group).is_active.take
  end

  def inactive_member_of?(group)
    self.memberships.for_group(group).is_inactive.take
  end

  def abbreviated_name
    "#{self.first_name} #{self.last_name.first}."
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def first_name=(v)
    v = v.capitalize if v.is_a?(String)
    super
  end

  def last_name=(v)
    v = v.capitalize if v.is_a?(String)
    super
  end

  def is_self?(member)
    self.id == member.id
  end

  def as_json(*)
    super.except(*JSON_EXCLUDES).tap do |m|
      id = m['id']
      m['path'] = member_path(id, format: :json)
      m['signout_path'] = signout_path(format: :json)
    end
  end

  def to_s
    self.persisted? ? "#{self.full_name}(#{self.id})" : self.class.to_s
  end

  protected

    def ensure_password
      unless self.password.present? || self.password_confirmation.present?
        self.password =
        self.password_confirmation = Rails.env.production? ? Devise.friendly_token : "pa$$w0rd"
      end unless self.persisted?
    end

    def is_required_address_field?(field)
      false
    end

end
