# == Schema Information
#
# Table name: membership_requests
#
#  id           :integer          not null, primary key
#  member_id    :integer          not null
#  gathering_id :integer          not null
#  sent_on      :datetime         not null
#  expires_on   :datetime         not null
#  message      :text(65535)
#  responded_on :datetime
#  status       :string(25)
#

class MembershipRequest < ActiveRecord::Base
  include Authority::Abilities
  include Ownable

  STATES = %w(answered accepted dismissed)

  belongs_to :member, required: true, inverse_of: :membership_requests
  belongs_to :gathering, required: true, inverse_of: :membership_requests

  after_initialize :ensure_defaults, unless: :persisted?

  before_validation :ensure_dates, unless: :persisted?
  before_validation :normalize_dates

  validates :member, belonging: {models: [Member]}
  validates :gathering, belonging: {models: [Gathering]}
  validates_datetime :sent_on, on_or_before: :today
  validates_datetime :expires_on, after: :sent_on
  validates_datetime :responded_on, after: :sent_on, allow_blank: true
  validates_inclusion_of :status, in: STATES, allow_blank: true
  validates_length_of :message, maximum: 2048

  validate :membership_status

  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}
  scope :for_member, lambda{|member| where(member: member)}

  scope :answered, lambda{where.not(responded_on: nil)}
  scope :unanswered, lambda{where(responded_on: nil)}

  scope :accepted, lambda{where(accepted: true)}
  scope :unaccepted, lambda{where.not(accepted: true)}
  scope :unexpired, lambda{where("expires_on >= ?", DateTime.current.end_of_day)}

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

  def dismiss!
    respond!('dismissed')
  end

  def dismissed?
    self.status == 'dismissed'
  end

  private

    def ensure_dates
      self.sent_on = DateTime.current unless self.sent_on.present?
      self.expires_on = self.sent_on + 1.month unless self.expires_on.present?
    end

    def ensure_defaults
      self.message ||= "I would like to join your Gathering."
    end

    def membership_status
      return unless self.gathering.present?
      return unless self.member.present?

      membership = self.member.memberships.for_group(self.gathering.community).take
      self.errors.add(:member, I18n.t(:unknown_member, scope: [:errors, :membership_request])) if membership.blank? || !membership.as_affiliate?

      membership = self.member.memberships.for_group(self.gathering).take
      self.errors.add(:member, I18n.t(:already_member, scope: [:errors, :membership_request])) if membership.present? && membership.as_participant?
    end

    def normalize_dates
      self.sent_on = self.sent_on.beginning_of_day if self.sent_on.acts_like?(:time)
      self.expires_on = self.expires_on.end_of_day if self.expires_on.acts_like?(:time)
    end

    def respond!(state)
      return unless state.present?
      if %w(accepted dismissed).include?(state) || self.status != 'accepted'
        self.status = state
        self.responded_on = DateTime.current
        self.save
      end
    end

end
