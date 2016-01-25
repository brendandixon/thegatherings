module Taggable
  extend ActiveSupport::Concern

  TAGS = %w(age_group gender life_stage relationship topic)

  class<<self
  
    def to_tags(set, *tags)
      m = Taggable.const_get(set.classify.pluralize) rescue nil if set.is_a?(String)
      m.present? ? (m.const_get('VALUES') & tags) : []
    end

    def scope_to_tags(o, params)
      TAGS.each do |set|
        next unless params[set].present?
        tags = to_tags(set, *params[set].split(','))
        o = o.tagged_with(tags, on: set.pluralize, any: true) if tags.present?
      end
      o
    end

  end

  module AgeGroups
    extend ActiveSupport::Concern

    VALUES = [
      'junior_high',
      'high_school',
      'college',
      'twenties',
      'thirties',
      'forties',
      'fifties',
      'sixties',
      'plus'
    ]
    OPTIONS = VALUES.map{|t| [t, I18n.t(t, scope:[:tags, :age_groups])]}

    included do
      acts_as_taggable_on :age_groups

      validates :age_group_list, tags: {allow_blank: true, values: VALUES}

      scope :for_age_groups, lambda{|*ages| tagged_with(ages, on: :age_groups, any: true)}
    end
  end

  module Genders
    extend ActiveSupport::Concern

    VALUES = [
      'women',
      'men',
      'mixed'
    ]
    OPTIONS = VALUES.map{|t| [t, I18n.t(t, scope: [:tags, :genders])]}

    included do
      acts_as_taggable_on :genders

      validates :gender_list, tags: {allow_blank: true, values: VALUES}

      scope :for_genders, lambda{|*genders| tagged_with(genders, on: :genders, any: true)}
    end
  end

  module LifeStages
    extend ActiveSupport::Concern

    VALUES = [
      'college',
      'post_college',
      'early_career',
      'established_career',
      'post_career'
    ]
    OPTIONS = VALUES.map{|t| [t, I18n.t(t, scope: [:tags, :life_stages])]}

    included do
      acts_as_taggable_on :life_stages

      validates :life_stage_list, tags: {allow_blank: true, values: VALUES}

      scope :for_life_stages, lambda{|*life_stages| tagged_with(life_stages, on: :life_stages, any: true)}
    end
  end

  module Relationships
    extend ActiveSupport::Concern

    VALUES = [
      'single',
      'young_married',
      'early_family',
      'established_family',
      'empty_nester',
      'divorced'
    ]
    OPTIONS = VALUES.map{|t| [t, I18n.t(t, scope: [:tags, :relationships])]}

    included do
      acts_as_taggable_on :relationships

      validates :relationship_list, tags: {allow_blank: true, values: VALUES}

      scope :for_relationships, lambda{|*relationships| tagged_with(relationships, on: :relationships, any: true)}
    end
  end

  module Topics
    extend ActiveSupport::Concern

    VALUES = [
      'bible',
      'mix',
      'devotional',
      'family',
      'marriage',
      'singleness',
      'men',
      'women'
    ]
    OPTIONS = VALUES.map{|t| [t, I18n.t(t, scope: [:tags, :topics])]}

    included do
      acts_as_taggable_on :topics

      validates :topic_list, tags: {allow_blank: true, values: VALUES}

      scope :for_topics, lambda{|*topics| tagged_with(topics, on: :topics, any: true)}
    end
  end

  included do
    include AgeGroups
    include Genders
    include LifeStages
    include Relationships
    include Topics
  end

  def is_tagged?(*tags)
    (tags.present? ? tags : TAGS).all?{|tag| self.send("#{tag}_list").length > 0}
  end

  def has_tags?(*tags)
    (tags.present? ? tags : TAGS).any?{|tag| self.send("#{tag}_list").length > 0}
  end
end
