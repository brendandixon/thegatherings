# == Schema Information
#
# Table name: checkups
#
#  id            :bigint(8)        not null, primary key
#  gathering_id  :bigint(8)        not null
#  week_of       :datetime         not null
#  gather_score  :integer
#  adopt_score   :integer
#  shape_score   :integer
#  reflect_score :integer
#  total_score   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Checkup < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'GatheringResourceAuthorizer'

  FORM_FIELDS = []

  belongs_to :gathering, inverse_of: :checkups

  has_one :community, through: :gathering
  has_one :campus, through: :gathering

  before_validation :ensure_defaults, if: :new_record?
  before_validation :normalize_scores
  before_validation :ensure_total_score
  before_validation :ensure_week_of

  validates :gathering, belonging: {models: [Gathering]}

  validates_datetime :week_of, on_or_before: :today
  validates_uniqueness_of :week_of, scope: :gathering

  validates_numericality_of :gather_score, :adopt_score, :shape_score, :reflect_score, :total_score,
    only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  scope :for_campus, lambda{|campus| where(campus: campus)}
  scope :for_campuses, lambda{|*campuses| where(campus_id: campuses)}
  scope :for_community, lambda{|community| where(community: community)}
  scope :for_gathering, lambda{|gathering| where(gathering: gathering)}

  scope :for_week_of, lambda{|dt| where(week_of: dt)}
  scope :since, lambda{|dt| where("week_of >= ?", dt)}
  scope :after, lambda{|dt| where("week_of >= ?", dt)}
  scope :before, lambda{|dt| where("week_of <= ?", dt)}
  scope :in_week_of_order, lambda{order(:week_of)}

  def as_json(*args, **options)
    super.except(*JSON_EXCLUDES).tap do |p|
      p['path'] = preference_path(self)
      p['community_path'] = community_path(self.community)
      p['campus_path'] = campus_path(self.campus)
      p['gathering_path'] = gathering_path(self.gathering)
    end
  end

  protected

    def ensure_defaults
      self.gather_score ||= 0
      self.adopt_score ||= 0
      self.shape_score ||= 0
      self.reflect_score ||= 0
    end

    def ensure_total_score
      self.total_score = self.gather_score
      self.total_score += self.adopt_score
      self.total_score += self.shape_score
      self.total_score += self.reflect_score
      self.total_score = (self.total_score / 400.0 * 100.0).round.to_i
    end

    def ensure_week_of
      return unless self.week_of.acts_like?(:time)
      self.week_of = self.week_of.beginning_of_week
    end

    def normalize_scores
      self.gather_score = self.gather_score.round.to_i if self.gather_score.present?
      self.adopt_score = self.adopt_score.round.to_i if self.adopt_score.present?
      self.shape_score = self.shape_score.round.to_i if self.shape_score.present?
      self.reflect_score = self.reflect_score.round.to_i if self.reflect_score.present?
    end

end
