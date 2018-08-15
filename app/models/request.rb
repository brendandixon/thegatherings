# == Schema Information
#
# Table name: requests
#
#  id            :bigint(8)        not null, primary key
#  community_id  :bigint(8)        not null
#  campus_id     :bigint(8)        not null
#  membership_id :bigint(8)        not null
#  gathering_id  :bigint(8)
#  sent_on       :datetime         not null
#  expires_on    :datetime         not null
#  message       :text(65535)
#  responded_on  :datetime
#  status        :string(25)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Request < ApplicationRecord
  include Authority::Abilities
  include Ownable

  STATUSES = %w(unanswered inprocess accepted dismissed)

  FORM_FIELDS = [:member_id, :request_id, :message]

  belongs_to :community, inverse_of: :requests
  belongs_to :campus, inverse_of: :requests
  belongs_to :gathering, inverse_of: :requests
  belongs_to :membership, inverse_of: :requests

  has_one :member, inverse_of: :requests, through: :membership
  has_one :request_owner, inverse_of: :request, dependent: :destroy
  
  after_initialize :ensure_defaults, if: :new_record?

  before_validation :ensure_campus, if: :new_record?
  before_validation :ensure_community, if: :new_record?
  before_validation :ensure_dates, if: :new_record?
  before_validation :normalize_dates

  validates :campus, belonging: {models: [Campus]}
  validates :membership, belonging: {models: [Membership]}
  validates :gathering, belonging: {models: [Gathering]}, allow_blank: true
  validates_datetime :sent_on, on_or_before: :today
  validates_datetime :expires_on, after: :sent_on
  validates_datetime :responded_on, after: :sent_on, allow_blank: true
  validates_inclusion_of :status, in: STATUSES, allow_blank: true
  validates_length_of :message, maximum: 2048

  validate :has_valid_membership_status
  validate :has_valid_responded_on

  scope :for_campus, lambda{|campus| where(campus: campus)}
  scope :for_community, lambda{|community| joins(:campus).where("campus.community_id = ?", community.id)}
  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}
  scope :for_member, lambda{|member| joins(:membership).where("membership.member_id = ?", member.id)}
  scope :for_membership, lambda{|membership| where(membership: membership)}

  scope :answered, lambda{where.not(responded_on: nil)}
  scope :unanswered, lambda{where(responded_on: nil)}

  scope :accepted, lambda{where(accepted: true)}
  scope :unaccepted, lambda{where.not(accepted: true)}
  scope :unexpired, lambda{where("expires_on >= ?", DateTime.current.end_of_day)}

  STATUSES.each do |status|
    class_eval <<-METHODS, __FILE__, __LINE__ + 1
      def #{status}!
        respond!('#{status}')
      end

      def #{status}?
        self.status == '#{status}'
      end
    METHODS
  end

  def respond!(status, responded_on = DateTime.current)
    responded_on = nil if status == 'unanswered'
    self.status = status
    self.responded_on = responded_on
    self.save
  end

  def completed?
    accepted? || dismissed?
  end

  def incomplete?
    !completed?
  end

  def as_json(*args, **options)
    logger.debug self.inspect
    super.except(*JSON_EXCLUDES).tap do |r|
      r['campus'] = self.campus.as_json if options[:deep] && self.campus.present?
      r['gathering'] = self.gathering.as_json if options[:deep] && self.gathering.present?
      r['member'] = self.member.as_json if options[:deep] && self.member.present?
      r['owner'] = self.request_owner.as_json if self.request_owner.present?
      r['path'] = request_path(self)
      r['campus_path'] = campus_path(self.campus)
      r['community_path'] = community_path(self.community)
      r['gathering_path'] = self.gathering.present? ? gathering_path(self.gathering) : nil
      r['member_path'] = member_path(self.member)
      r['membership_path'] = membership_path(self.membership)
      r['respond_path'] = respond_request_path(self)
    end
  end

  protected

    def ensure_campus
      self.campus ||= self.gathering.campus if self.gathering.present?
    end

    def ensure_community
      self.community ||= self.campus.community if self.campus.present?
    end

    def ensure_dates
      self.sent_on = DateTime.current unless self.sent_on.present?
      self.expires_on = self.sent_on + 1.month unless self.expires_on.present?
    end

    def ensure_defaults
      self.status = 'unanswered'
      self.message ||= "I would like to join your Gathering."
    end

    def has_valid_membership_status
      return unless self.campus.present?
      return unless self.gathering.present?
      return unless self.membership.present?

      if !self.membership.to?(self.campus)
        self.errors.add(:membership, "membership is not in the Gathering campus")
      elsif self.member.memberships.for_group(self.gathering).exists?
        self.errors.add(:membership, I18n.t(:already_member, scope: [:errors, :request]))
      end
    end

    def has_valid_responded_on
      return unless self.status.present?
      return if self.unanswered? == self.responded_on.blank?
      self.errors.add(:responded_on, "status and responded_on must be both present or absent")
    end

    def normalize_dates
      self.sent_on = self.sent_on.beginning_of_day if self.sent_on.acts_like?(:time)
      self.expires_on = self.expires_on.end_of_day if self.expires_on.acts_like?(:time)
    end

end
