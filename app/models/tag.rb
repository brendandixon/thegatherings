# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        unsigned, not null, primary key
#  tag_set_id :bigint(8)        not null
#  name       :string(255)
#  prompt     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'CommunityAuthorizer'

  FORM_FIELDS = [:tag_set_id, :name]

  belongs_to :tag_set
  has_one :community, through: :tag_set

  has_many :taggings, dependent: :destroy

  before_validation :ensure_prompt

  validates :tag_set, belonging: {models: [TagSet]}

  validates_presence_of :name
  validates_format_of :name, with: REGEX_TERM
  validates_uniqueness_of :name, scope: :tag_set

  validates_presence_of :prompt
  validates_length_of :prompt, within: 3..255
  validates_format_of :prompt, with: REGEX_PHRASE, unless: Proc.new{|t| t.errors.has_key?(:prompt)}

  scope :from_set, lambda{|tag_set| where(tag_set: tag_set)}
  scope :with_name, lambda{|name| where(name: name)}

  def as_json(*)
    super.except(*JSON_EXCLUDES).tap do |p|
      p['path'] = tag_path(p['id'], format: :json)
      p['tag_set_path'] = tag_set_path(p['tag_set_id'], format: :json)
    end
  end

  def to_s
    self.prompt
  end

  protected

    def ensure_prompt
      self.prompt = self.name if self.prompt.blank?
    end

end
