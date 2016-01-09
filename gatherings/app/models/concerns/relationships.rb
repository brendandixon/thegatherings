module Relationships
  extend ActiveSupport::Concern

  RELATIONSHIPS = [
    'single',
    'young_married',
    'early_family',
    'established_family',
    'empty_nester',
    'divorced'
  ]

  included do
    acts_as_taggable_on :relationship

    validates :relationship_list, tags: {allow_blank: true, values: RELATIONSHIPS}
  end

  module ClassMethods

    def relationships_collection
      RELATIONSHIPS.map{|g| [g, I18n.t(g, scope: [:tags, :relationships])]}
    end

  end

end
