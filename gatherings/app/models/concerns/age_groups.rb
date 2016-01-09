module AgeGroups
  extend ActiveSupport::Concern

  AGE_GROUPS = [
    'twenties',
    'thirties',
    'forties',
    'fifties',
    'sixties',
    'plus'
  ]

  included do
    acts_as_taggable_on :age_groups

    validates :age_group_list, tags: {allow_blank: true, values: AGE_GROUPS}
  end

  module ClassMethods

    def age_groups_collection
      AGE_GROUPS.map{|g| [g, I18n.t(g, scope:[:tags, :age_groups])]}
    end

  end

end
