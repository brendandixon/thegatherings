module Relationships
  extend ActiveSupport::Concern

  RELATIONSHIPS = [
    'relationship_single',
    'relationship_young_married',
    'relationship_early_family',
    'relationship_established_family',
    'relationship_empty_nester',
    'relationship_divorced'
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
