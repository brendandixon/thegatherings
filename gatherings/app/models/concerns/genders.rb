module Genders
  extend ActiveSupport::Concern

  GENDERS = [
    'gender_women',
    'gender_men',
    'gender_mixed'
  ]

  included do
    acts_as_taggable_on :genders

    validates :gender_list, tags: {allow_blank: true, limit: 1, values: GENDERS}
  end

  module ClassMethods

    def genders_collection
      GENDERS.map{|g| [g, I18n.t(g, scope: [:tags, :genders])]}
    end

  end

end
