# == Schema Information
#
# Table name: requests
#
#  id           :bigint(8)        not null, primary key
#  member_id    :bigint(8)        not null
#  campus_id    :bigint(8)        not null
#  gathering_id :bigint(8)
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  message      :text(65535)
#  responded_on :datetime
#  status       :string(25)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Request < ApplicationRecord
  include Authority::Abilities
  include Ownable

  STATES = %w(answered accepted dismissed)

  FORM_FIELDS = [:member_id, :gathering_id, :message]

  belongs_to :member, inverse_of: :requests
  belongs_to :campus, inverse_of: :requests
  belongs_to :gathering, inverse_of: :requests

  has_one :community, through: :campus
  
  after_initialize :ensure_defaults, unless: :persisted?

  before_validation :ensure_campus
  before_validation :ensure_dates, unless: :persisted?
  before_validation :normalize_dates

  validates :campus, belonging: {models: [Campus]}
  validates :member, belonging: {models: [Member]}
  validates :gathering, belonging: {models: [Gathering]}, allow_blank: true
  validates_datetime :sent_on, on_or_before: :today
  validates_datetime :expires_on, after: :sent_on
  validates_datetime :responded_on, after: :sent_on, allow_blank: true
  validates_inclusion_of :status, in: STATES, allow_blank: true
  validates_length_of :message, maximum: 2048

  validate :has_valid_membership_status
  validate :has_valid_responded_on

  scope :for_campus, lambda{|campus| where(campus: campus)}
  scope :for_community, lambda{|community| joins(:campus).where("campus.community_id = ?", community.id)}
  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}
  scope :for_member, lambda{|member| where(member: member)}

  scope :answered, lambda{where.not(responded_on: nil)}
  scope :unanswered, lambda{where(responded_on: nil)}

  scope :accepted, lambda{where(accepted: true)}
  scope :unaccepted, lambda{where.not(accepted: true)}
  scope :unexpired, lambda{where("expires_on >= ?", DateTime.current.end_of_day)}

  def unanswer!
    respond!(nil, nil)
  end
  
  def unanswered?
    self.status.blank?
  end

  def answer!
    respond!('answered')
  end

  def answered?
    self.status.present?
  end

  def accept!
    respond!('accepted')
  end

  def accepted?
    self.status == 'accepted'
  end

  def completed?
    accepted? || dismissed?
  end

  def incomplete?
    !completed?
  end

  def dismiss!
    respond!('dismissed')
  end

  def dismissed?
    self.status == 'dismissed'
  end

  protected

    def ensure_campus
      self.campus = self.gathering.campus if self.campus.blank? && self.gathering.present?
    end

    def ensure_dates
      self.sent_on = DateTime.current unless self.sent_on.present?
      self.expires_on = self.sent_on + 1.month unless self.expires_on.present?
    end

    def ensure_defaults
      self.message ||= "I would like to join your Gathering."
    end

    def has_valid_membership_status
      return unless self.gathering.present?
      return unless self.member.present?

      membership = self.member.memberships.for_group(self.gathering).take
      self.errors.add(:member, I18n.t(:already_member, scope: [:errors, :request])) if membership.present?
    end

    def has_valid_responded_on
      return if self.status.present? == self.responded_on.present?
      self.errors.add(:responded_on, "status and responded_on must be both present or absent")
    end

    def normalize_dates
      self.sent_on = self.sent_on.beginning_of_day if self.sent_on.acts_like?(:time)
      self.expires_on = self.expires_on.end_of_day if self.expires_on.acts_like?(:time)
    end

    def respond!(state, responded_on = DateTime.current)
      state = "accepted" if accepted? && state == "answered"
      self.status = state
      self.responded_on = responded_on
      self.save
    end

end
