module LifeStages
  extend ActiveSupport::Concern

  LIFE_STAGES = [
    'college',
    'post_college',
    'early_career',
    'established_career',
    'post_career'
  ]

  included do
    acts_as_taggable_on :life_stages

    validates :life_stage_list, tags: {allow_blank: true, values: LIFE_STAGES}
  end

  module ClassMethods

    def life_stages_collection
      LIFE_STAGES.map{|g| [g, I18n.t(g, scope: [:tags, :life_stages])]}
    end

  end

end
