# == Schema Information
#
# Table name: members
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  gender                 :string(25)       default(""), not null
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)
#  postal_code            :string(25)
#  country                :string(2)
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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string(255)
#  uid                    :string(255)
#

class Member < ApplicationRecord
  include Authority::UserAbilities
  include Authority::Abilities
  include Addressed
  include Phoneable

  GENDERS = %w(female male)

  has_address_of :country, :postal_code, :time_zone

  has_many :memberships, inverse_of: :member, dependent: :destroy
  has_many :communities, through: :memberships, source: :group, source_type: "Community"
  has_many :campuses, through: :memberships, source: :group, source_type: "Campus"
  has_many :gatherings, through: :memberships, source: :group, source_type: "Gathering"
  
  has_many :attendance_records, through: :memberships, dependent: :destroy
  has_many :membership_requests, inverse_of: :member, dependent: :destroy

  before_validation :ensure_password
  before_validation :ensure_time_zone

  validates_length_of :first_name, within: 1..255
  validates_length_of :last_name, within: 1..255
  validates_length_of :email, within: 6..255
  validates :email, email: true
  validates_uniqueness_of :email
  validates_inclusion_of :gender, in: GENDERS

  scope :for_email, lambda{|email| where(email: email)}

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

  def become!(group, role)
    Membership.become!(group, self, role)
  end

  def join!(group, role = nil)
    Membership.join!(group, self, role)
  end

  def affiliate_of?(group)
    m = membership_in(group)
    m.present? && m.as_affiliate?
  end

  def overseer_for?(group)
    m = membership_in(group)
    m.present? && m.as_overseer?
  end

  def assistant_for?(group)
    m = membership_in(group)
    m.present? && m.as_assistant?
  end

  def coach_for?(group)
    m = membership_in(group)
    m.present? && m.as_coach?
  end

  def participant_in?(group)
    m = membership_in(group)
    m.present? && m.as_participant?
  end

  def visitor_to?(group)
    m = membership_in(group)
    m.present? && m.as_visitor?
  end

  def member_of?(group)
    membership_in(group).present?
  end

  def membership_in(group)
    self.memberships.for_group(group).take
  end

  def memberships_in(klass)
    self.memberships.in_groups(klass)
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

    def ensure_time_zone
      self.time_zone = TheGatherings::Application.default_time_zone if self.time_zone.blank?
    end

end
