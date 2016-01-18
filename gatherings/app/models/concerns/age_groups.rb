module AgeGroups
  extend ActiveSupport::Concern

  AGE_GROUPS = [
    'age_group_twenties',
    'age_group_thirties',
    'age_group_forties',
    'age_group_fifties',
    'age_group_sixties',
    'age_group_plus'
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
