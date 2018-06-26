# == Schema Information
#
# Table name: tag_sets
#
#  id           :bigint(8)        unsigned, not null, primary key
#  community_id :bigint(8)
#  name         :string(255)
#  single       :string(255)
#  plural       :string(255)
#  prompt       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class TagSet < ApplicationRecord
  include Authority::Abilities
  self.authorizer_name = 'CommunityAuthorizer'

  DEFAULT_TAG_SETS = {
    demographics: [
      'college',
      'twenties',
      'thirties',
      'forties',
      'fifties',
      'sixties',
      'plus'
    ],

    genders: [
      'women',
      'men',
      'mixed'
    ], 

    life_stages: [
      'college',
      'post_college',
      'early_career',
      'established_career',
      'post_career'
    ],

    relationships: [
      'single',
      'young_married',
      'early_family',
      'established_family',
      'empty_nester',
      'divorced'
    ],

    topics: [
      'bible',
      'topical',
      'devotional',
      'family',
      'marriage',
      'singleness',
      'men',
      'women'
    ]
  }

  FORM_FIELDS = [:community_id, :name]

  belongs_to :community

  has_many :tags, dependent: :destroy
  has_many :taggings, through: :tags

  before_validation :ensure_single
  before_validation :ensure_plural
  before_validation :ensure_prompt

  validates :community, belonging: {models: [Community]}

  validates_format_of :name, with: REGEX_TERM
  validates_uniqueness_of :name, scope: :community

  validates_presence_of :single
  validates_format_of :single, with: REGEX_WORD

  validates_presence_of :plural
  validates_format_of :plural, with: REGEX_WORD

  validates_presence_of :prompt
  validates_length_of :prompt, within: 3..255
  validates_format_of :prompt, with: REGEX_PHRASE, unless: Proc.new{|t| t.errors.has_key?(:prompt)}

  scope :for_community, lambda{|community| where(community: community)}
  scope :with_name, lambda{|name| where(name: name)}

  class<<self

    def add_defaults!(community)
      return if community.blank?
      TagSet.transaction do
        DEFAULT_TAG_SETS.keys.each {|name| add_default!(name, community)}
      end
    end

    def add_default!(name, community)
      return if name.blank? || community.blank?

      name = name.to_sym
      return unless DEFAULT_TAG_SETS.has_key?(name)

      TagSet.transaction do
        single = I18n.t(:single, scope: [:tags, name])
        plural = I18n.t(:plural, scope: [:tags, name])
        prompt = I18n.t(:prompt, scope: [:tags, name])

        tag_set = community.tag_sets.create(name: name, single: single, plural: plural, prompt: prompt)
        tag_set.add_tags!(*DEFAULT_TAG_SETS[name].map{|tag| {name: tag, prompt: I18n.t(tag, scope: [:tags, name])}})
      end
    end

  end

  def add_tags!(*tags)
    tags.flatten!
    tags = tags.map{|tag| tag.is_a?(String) ? {name: tag} : tag}
    if new_record?
      tags.each {|tag| self.tags.build(tag)}
    else
      self.class.transaction do
        tags.each {|tag| self.tags.create!(tag)}
      end
    end
  end
  alias :add_tag! :add_tags!

  def remove_tags!(*names)
    names.flatten!
    self.tags.with_name(names).delete_all
    self.tags.reload
  end
  alias :remove_tag! :remove_tags!

  def normalize_tags(*possible_tags)
    return [] if possible_tags.blank?

    tags = self.tags.to_a
    possible_tags = possible_tags.map do |pt|
                      if pt.is_a?(Tag)
                        tags.find{|t| t.id == pt.id}
                      elsif pt.is_a?(Integer)
                        tags.find{|t| t.id == pt}
                      elsif pt.is_a?(String) || pt.is_a?(Symbol)
                        tags.find{|t| t.name == pt.to_s}
                      else
                        nil
                      end
                    end

    possible_tags.compact
  end

  def as_json(*)
    super.except(*JSON_EXCLUDES).tap do |ts|
      id = ts['id']
      ts['tags'] = self.tags
      ts['path'] = tag_set_path(id, format: :json)
      ts['community_path'] = community_path(ts['community_id'], format: :json)
      ts['tags_path'] = tag_set_tags_path(id, format: :json)
    end
  end

  def to_s
    self.name
  end

  protected

    def ensure_plural
      return if self.plural.present? || self.single.blank?
      self.plural = self.single.pluralize
    end

    def ensure_prompt
      return if self.prompt.present?
      self.prompt = I18n.t(:prompt, scope: :tags, tag_set_name: self.plural)
    end

    def ensure_single
      return if self.single.present? || self.name.blank?
      self.single = self.name.humanize
    end

end
